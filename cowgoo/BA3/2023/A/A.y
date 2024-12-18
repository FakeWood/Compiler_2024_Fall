%{
#include <stdio.h>
#include <stdlib.h>

int yylex();
void yyerror(const char *s);

%}

%union {
float fval;
}

%token <fval> NUM
%token OTHERS

%left '+' '-'
%left '*' '/'

%type <fval> exprs

%%

program: exprs          {printf("%.3f", $1);}
;

exprs: exprs '+' exprs     {$$ = $1 + $3;}
     | exprs '-' exprs     {$$ = $1 - $3;}     
     | exprs '*' exprs     {$$ = $1 * $3;}     
     | exprs '/' exprs     {if ($3 == 0) {yyerror("");} $$ = $1 / $3;}
     | NUM
     | OTHERS              {yyerror("");}
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