%{
    #include "string.h"
%}

%option noyywrap

INTEGER     [0-9]+
FLOAT       ^[+\-]?[0-9]+\.[0-9]+
STRING      ^\"[^\"\n]*\"
STRINGG     ^\'[^\'\n]*\'
BOOLEAN     ^"true"|^"false"
OPERATION   ^[0-9]+[\+\-\*\/0-9]+
%%

{INTEGER}     {ECHO; printf(" INTEGER");}
{FLOAT}       {ECHO; printf(" FLOAT");}
{STRING}      {ECHO; printf(" STRING");}
{STRINGG}      {ECHO; printf(" STRING");}
{BOOLEAN}     {ECHO; printf(" BOOLEAN");}
{OPERATION}   {{ECHO; printf(" OPERATION");}}
^[^\n]+       {if(strcmp(yytext, "true") == 0 || strcmp(yytext, "false") == 0) {ECHO; printf(" BOOLEAN");} else {ECHO; printf(" INVALID");}}
.             {printf("x");}
\n            {ECHO;}

%%

int main(int argc, char *argv[]) {
	yylex();
	return(0);
}