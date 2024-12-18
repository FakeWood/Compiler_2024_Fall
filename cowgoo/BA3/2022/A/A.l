%{
#include "string.h"
#include "A.tab.h"
%}

%option noyywrap

NUMBER     [+\-]?[1-9]+[0-9]*

%%

{NUMBER}           {yylval.ival = atoi(yytext); return NUM;}
"+"|"-"            {return yytext[0];}
"P"|"p"            {return P;}
"C"|"c"            {return C;}
"\n"|"t"           {}
.                  {}

%%