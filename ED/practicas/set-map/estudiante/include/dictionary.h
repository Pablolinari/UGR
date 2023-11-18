#ifndef __DICTIONARY_H__
#define __DICTIONARY_H__
#include <set>
#include <string>
#include <vector>
#include <iostream>

using namespace std;


/**
 * @brief TDA Dictionary
 * @details Almacena las palabras de un fichero de texto y permite iterar sobre ellas
 *
 */

 class Dictionary{

private:
    set <string> words;
public:

    Dictionary();
    Dictionary(const Dictionary & d);
    bool exist(const string & word) const;
    bool insert(const string & word);
    bool erase(const string & word);
    void clear();
    bool empty()const;
    int size()const;
    vector<string> wordsLenght(int l);
    int ocurrence(const char c);
    void aniade(const Dictionary & dic);

    friend ostream  & operator << (ostream  & os , const Dictionary &d){
        set<string> :: iterator it;
        for(it = d.words.begin(); it != d.words.end(); ++it){
            os << *it << endl;
        }
        return os;
    }
    
    friend istream  & operator >> (istream  & is ,  Dictionary &d){
        set<string> :: iterator it;
        string word;
        int i = 0 ;
        while(i != 8){
            is >> word;
            d.words.insert(word);
            i++;
        }
        return is;
    }

    

 };

#endif
