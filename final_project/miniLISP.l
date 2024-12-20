%{
#include "string.h"
#include "miniLISP.tab.h"
%}

%option noyywrap

DIGIT      0|"-"?[1-9][0-9]*
ID         [a-z]([0-9a-z\-])*
BOOL       "#T"|"#F"

%%

{DIGIT}                {yylval.ival = atoi(yytext); return NUM;}
{BOOL}                 {yylval.ival = 0; return BOOL;}
{ID}                   {if(strcmp(yytext, "print-num") == 0) {
                            return PRINT_NUM; 
                        } else if(strcmp(yytext, "print-bool") == 0) {
                            return PRINT_BOOL;
                        } else if(strcmp(yytext, "mod") == 0) {
                            return MOD;
                        } else if(strcmp(yytext, "and") == 0) {
                            return AND;
                        } else if(strcmp(yytext, "or") == 0) {
                            return OR;
                        } else if(strcmp(yytext, "not") == 0) {
                            return NOT;
                        } else if(strcmp(yytext, "define") == 0) {
                            return DEF;
                        } else if(strcmp(yytext, "fun") == 0) {
                            return FUNC;
                        } else if(strcmp(yytext, "if") == 0) {
                            return IF;
                        }
                        else {
                            yylval.str = yytext; 
                            return ID;
                        } 
                        }
"\n"|"\r"|"\t"|" "     {}
.                      {}
%%