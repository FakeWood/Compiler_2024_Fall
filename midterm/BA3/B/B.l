%{
#include "string.h"
#include "B.tab.h"
%}

%option noyywrap

DIGIT      [1-9][0-9]*

%%

{DIGIT}       {yylval.ival = atoi(yytext); return NUM;}
"0"           {return END;}
"\n"|"\t"     {}
.             {}
%%