%{
#include <stdio.h>
#include <stdlib.h>

int yylex();
void yyerror(const char *s);
void semantic_error(int col);
%}

%union {
int ival;
struct {int i; int j;} mat;
}

%token <ival> NUM
%token <ival> ADD SUB MUL
%token TRAN

%type <mat> terms mul term
%type <mat> matrix

%right TRAN
%left ADD SUB
%left MUL

%%

expression: terms {printf("Accepted\n");}
;

terms: terms ADD mul
        {
            if ($1.i == $3.i && $1.j == $3.j) { $$.i = $1.i; $$.j = $1.j;}
            else {semantic_error($2);}
        }
    | terms SUB mul
        {
            if ($1.i == $3.i && $1.j == $3.j) { $$.i = $1.i; $$.j = $1.j;}
            else {semantic_error($2);}
        }
    | mul
;

mul: mul MUL term
        {
            if ($1.j == $3.i) { $$.i = $1.i; $$.j = $3.j;}
            else {semantic_error($2);}
        }
    | term
;

term: '(' terms ')'
        {
            $$.i = $2.i;
            $$.j = $2.j;
        }
    | term TRAN
        {
            int tmp = $$.i;
            $$.i = $$.j;
            $$.j = tmp;
        }
    | matrix
        {
            $$.i = $1.i;
            $$.j = $1.j;
        }
;

matrix: '[' NUM ',' NUM ']'
        {
            $$.i = $2;
            $$.j = $4;
        }
;

%%

void semantic_error(int col) {
    printf("Semantic error on col %d\n", col);
    exit(0);
}

void yyerror(const char *s) {
    /* printf("%s", s); */
    printf("Syntax Error\n");
    exit(0);
    return;
}

int main() {
    yyparse();

    return 0;
}