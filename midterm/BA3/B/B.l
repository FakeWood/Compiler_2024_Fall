%{
#include "string.h"
#include "B.tab.h"

int col = 0;
%}

%option noyywrap

DIGIT      [1-9][0-9]*
ELSE       "["|"]"|"("|")"|","

%%

{DIGIT}       {col += yyleng; yylval.ival = atoi(yytext); return NUM;}
"+"           {col += yyleng; yylval.ival = col; return ADD;}
"-"           {col += yyleng; yylval.ival = col; return SUB;}
"*"           {col += yyleng; yylval.ival = col; return MUL;}
"^T"          {col += yyleng; return TRAN;}
" "           {col += yyleng;}
{ELSE}        {col += yyleng; return yytext[0];} 
"\n"          {col += yyleng;}
.             {col += yyleng;}

%%