%{
    #include "string.h"
    string temp;
    int isFirst
%}

%option noyywrap

INTEGER     [+\-]?[0-9]+
FLOAT       [+\-]?[0-9]*\.[0-9]+
STRING      (\"[^\"]+\"" ")|(\'[^\']+\'" ")
VARIABLE    [a-zA-Z0-9\_]+

%%

{INTEGER}     {ECHO; printf("INTERGER\n"); temp = yytext;}
{FLOAT}       {ECHO; printf("FLOAT\n");}
{STRING}      {ECHO; printf("STRING\n");}
{VARIABLE}    {if(!(yytext[0] >= '0' && yytext[0] <= '9')) {ECHO; printf("VARIABLE\n");}}
.             {}
\n            {}

%%

int main(int argc, char *argv[]) {
	yylex();
	return(0);
}