%{
#include "string.h"
#include "A.tab.h"
%}

%option noyywrap

NUMBER     -?[0-9]+(.[0-9]+)?

%%

{NUMBER}                     {yylval.fval = atof(yytext); return NUM;}
"f"|"g"|"h"|"("|")"|","      {return yytext[0];}
"\n"|"t"                     {}
.                            {}

%%