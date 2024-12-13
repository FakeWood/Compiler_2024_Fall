%{
#include "string.h"
#include "y.tab.h"
%}

%option noyywrap

INTEGER     ^[+\-]?[0-9]+$

%%

{INTEGER}     {yylval.ival = atoi(yytext) return NUM;}
"load"        {return LOAD;}
"add"         {return ADD;}
"sub"         {return SUB;}
"mul"         {return MUL;}
"mod"         {return MOD;}
"inc"         {return INC;}
"dec"         {return DEC;}
.

%%

int main(int argc, char *argv[]) {
	yylex();
	return(0);
}