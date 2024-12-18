%{
#include <stdio.h>
#include <stdlib.h>

int yylex();
void yyerror(const char* message);

int factor(int n);
int permutation(int n, int k);
int combination(int m, int n);
%}

%union {
int ival;
}

%token <ival> NUM
%token P C

%type <ival> exprs expr term

%%

program: exprs         {printf("%d", $1)}
;

exprs: exprs expr
     | expr
;

expr: term '+' term    {$$ = $1 + $3;}
    | term '-' term    {$$ = $1 - $3;}
;

term : P NUM NUM       {$$ = permutation($2, $3);}
     | C NUM NUM       {$$ = combination($2, $3);}
     | NUM             {$$ = $1;}
;

%%

int factor(int n) {
    int tmp = 1;
    for (int i=n; i>0; i--) {
        tmp *= i;
    }
    return tmp;
}

int permutation(int n, int k) {
    return factor(n) / factor(n-k);
}

int combination(int m, int n) {
    return (factor(m) / (factor(n) * factor(m-n)));
}

void yyerror(const char *s) {
    printf("Wrong Formula");
    exit(0);
    return;
}

int main() {
    yyparse();
    return 0;
}