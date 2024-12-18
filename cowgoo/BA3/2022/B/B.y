%{
#include <stdio.h>
#include <stdlib.h>

int yylex();
void yyerror(const char* message);
%}

%union {
int ival;
struct {
    int t;
    int f;
} bval;
}

%token AND_S AND_E OR_S OR_E NOT_S NOT_E
%token <bval> T F

%type <bval> exprs expr

%%

program: expr               {if($1.t == 1) printf("true"); else printf("false")}
;

expr:  AND_S exprs AND_E    {$$.t = 1 - $2.f; $$.f = 0;}
     | AND_S AND_E          {$$.t = 1; $$.f = 0}
     | OR_S exprs OR_E      {$$.t = $2.t; $$.f = 0;}
     | OR_S  OR_E           {$$.t = 0; $$.f = 1}
     | NOT_S exprs NOT_E    {$$.t = 1 - $2.t; $$.f = 0;}
     | T                    {$$.t = 1; $$.f = 0;}
     | F                    {$$.t = 0; $$.f = 1;}

exprs: exprs expr           {if($1.t == 1 || $2.t == 1) $$.t = 1; else $$.t = 0; if($1.f == 1 || $2.f == 1) $$.f = 1; else $$.f = 0;}
     | expr                 {$$ = $1;}
;

%%

void yyerror(const char *s) {
    printf("Invalid Value");
    exit(0);
    return;
}

int main() {
    yyparse();
    return 0;
}