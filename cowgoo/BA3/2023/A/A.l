%{
#include "string.h"
#include "A.tab.h"
%}

%option noyywrap

FLOAT     [1-9]*[0-9]*"."?[0-9]*

%%

{FLOAT}             {yylval.fval = atof(yytext); return NUM;}
"+"|"-"|"*"|"/"     {return yytext[0];}
"\n"|"t"|" "        {}
.                   {return OTHERS;}

%%