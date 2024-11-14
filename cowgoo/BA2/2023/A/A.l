%{
    #include "string.h"
%}

%option noyywrap

INTEGER     ^[+\-]?[0-9]+$
FLOAT       ^[+\-]?[0-9]*\.[0-9]+$
STRING      ^\"[^\"\n]+\"\n|^\'[^\'\n]+\'\n
VARIABLE    ^[a-zA-Z\_][a-zA-Z0-9\_]*$
%%

{INTEGER}     {ECHO; printf(" INTERGER\n");}
{FLOAT}       {ECHO; printf(" FLOAT\n");}
{STRING}      {for(int i = 0; i < yyleng - 1; i++) printf("%c",yytext[i]); printf(" STRING\n");}
{VARIABLE}    {{ECHO; printf(" VARIABLE\n");}}
.             {}
\n            {}

%%

int main(int argc, char *argv[]) {
	yylex();
	return(0);
}