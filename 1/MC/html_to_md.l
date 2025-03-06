%{
#include <stdio.h>
#include <string.h>

void convert_to_markdown(const char *tag, const char *content);
%}

%%
"<h1>" { convert_to_markdown("h1", yytext); }
"<h2>" { convert_to_markdown("h2", yytext); }
"<p>" { convert_to_markdown("p", yytext); }
"<a href=\"" { convert_to_markdown("a", yytext); }
"<strong>" { convert_to_markdown("strong", yytext); }
"<em>" { convert_to_markdown("em", yytext); }
"</h1>" { /* Ignorar */ }
"</h2>" { /* Ignorar */ }
"</p>" { /* Ignorar */ }
"</a>" { /* Ignorar */ }
"</strong>" { /* Ignorar */ }
"</em>" { /* Ignorar */ }
. { printf("%s", yytext); }
%%

void convert_to_markdown(const char *tag, const char *content) {
    if (strcmp(tag, "h1") == 0) {
        printf("# %s\n\n", content);
    } else if (strcmp(tag, "h2") == 0) {
        printf("## %s\n\n", content);
    } else if (strcmp(tag, "p") == 0) {
        printf("%s\n\n", content);
    } else if (strcmp(tag, "a") == 0) {
        printf("[%s](%s)\n\n", content, content); // Simplificación
    } else if (strcmp(tag, "strong") == 0) {
        printf("**%s**", content);
    } else if (strcmp(tag, "em") == 0) {
        printf("_%s_", content);
    }
}

int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            perror("Error al abrir el archivo");
            return 1;
        }
        yyin = file;
        yylex();
        fclose(file);
    } else {
        fprintf(stderr, "Uso: %s <archivo_html>\n", argv[0]);
        return 1;
    }
    return 0;
}