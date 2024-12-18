%{
#include "string.h"
#include "B.tab.h"
%}

%option noyywrap

NUMBER     0|[1-9][0-9]*|-[1-9][0-9]*

%%

{NUMBER}             {yylval.ival = atoi(yytext); return NUM;}
"+"|"-"|"*"|"/"     {return yytext[0];}
"\n"|"t"|" "        {}
.                   {}

%%