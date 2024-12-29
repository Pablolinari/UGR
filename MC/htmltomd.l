%option noyywrap
%{
#include <iostream>
#include <fstream>
#include <string>
using namespace std;

// Variables para contar líneas, palabras y caracteres
ifstream infile;
void processtag(string c);
void processorderedlist(string c);
void processunorderedlist(string c);
void processtitle(string c);

%}

texto (.|\s)*
htmltag <html.*>
htmltagc <\/html>
etiq1 <h1>
etiq1c <\/h1>
etiq2 <h2>
etiq2c <\/h2>
etiq3 <h3>
etiq3c <\/h3>
plaintext <p>
plaintextc <\/p>
body <body>
bodyc <\/body>
ulist <ul>
ulistc <\/ul>
olist <ol>
olistc <\/ol>
main <main>
mainc <\/main>
header <head>
headerc <\/head>
any (\t|\n)*
tagh1 {etiq1}{texto}{etiq1c}
tagh2 {etiq2}{texto}{etiq2c}			
tagh3 {etiq3}{texto}{etiq3c}	
tagtext {plaintext}{texto}{plaintextc}	
unorderedlist {ulist}({any}|{texto})*{ulistc}
orderedlist {olist}({any}|{texto})*{olistc}
titulo {header}({any}|{texto})*{headerc}
doctype <!DOCTYPE.*>

%%



{doctype}|({main}|{mainc})|({body}|{bodyc})|({htmltag}|{htmltagc})	{cout << "";}
{titulo}								{processtitle(yytext);}
{tagh1}							    {processtag(yytext);}
{tagh2}									{processtag(yytext);}
{tagh3}									{processtag(yytext);}
{tagtext}								{processtag(yytext);}
{orderedlist}						{processorderedlist(yytext);}
{unorderedlist}					{processunorderedlist(yytext);}

%%

void processtag(string c) {
		string tag = c.substr(0,4);
		string replace ="";
		string cad = c.substr(4,c.size()-9);
		if(tag == "<h1>"){
			replace ="# ";
		}else if(tag =="<h2>"){
			replace = "## ";
		}else if(tag == "<h3>"){
			replace ="### ";
		}else {
			cad = c.substr(3,c.size()-7);
			replace ="";
		}
		cout << replace << cad<<endl; 
}
void processunorderedlist(string c) {
	int pos = c.find("<ul>");
	string cad =c;
	cad.erase(pos,4);
	pos = cad.find("</ul>");
	cad.erase(pos,5);
	while (true){
		pos = cad.find("<li>");
		if(pos == string::npos) break;
		cad.erase(pos,4);
		cad = cad.insert(pos,"\n -");
		pos =cad.find("</li>");
		cad.erase(pos,5);	
	}
	
	cout << cad << endl;
}
void processorderedlist(string c) {
	int pos = c.find("<ol>");

	string cad =c;
	string aux="";
	cad.erase(pos,4);
	pos = cad.find("</ol>");
	cad.erase(pos,5);
	int cont =0;
	while (true){
		pos = cad.find("<li>");
		cont++;
		if(pos == string::npos) break;
		cad.erase(pos,4);
		aux+="\n"+to_string(cont)+". ";
		cad = cad.insert(pos,aux);
		aux="";
		pos =cad.find("</li>");
		cad.erase(pos,5);	
	}
	
	cout << cad << endl;
}
void processtitle(string c){
	int pos = c.find("<head>");
	c.erase(pos,8);
	pos =c.find("</head>");
	c.erase(pos,9);
	pos = c.find("<h");
	c.erase(pos,4);	
	pos = c.find("</h");
	c.erase(pos,5);

	c+="\n--------------------------------------------------------------\n";
	c="\n--------------------------------------------------------------\n"+c;
	cout << c;
}
int main(int argc, char **argv) {
    if (argc != 2) {
        cerr << "Usage: " << argv[0] << " <input_html_file>" << endl;
        return 1;
    }

  	infile.open(argv[1]);
    if (!infile.is_open()) {
        cerr << "Failed to open file: " << argv[1] << endl;
        return 1;
    }
		yyFlexLexer flujo (&infile,0);
		flujo.yylex();
    infile.close();


    return 0;
}

