%{
#include <stdio.h>
#include <stdlib.h>
#include <stack>

int stack[100];
int sp = -1;
%}

%union {
int ival;
}


%token <ival> NUM
%token LOAD
%token ADD SUB MUL MOD
%token INC DEC
%token END

%%

program: lines
;

lines: line lines
     | line
;

line: LOAD NUM  {stack[++sp] = $2;}
    | ADD       {stack[sp--] += stack[sp];}
    | SUB       {stack[sp--] -= stack[sp];}
    | MUL       {stack[sp--] *= stack[sp];}
    | MOD       {stack[sp--] %= stack[sp];}
    | INC       {stack[sp] += 1;}
    | DEC       {stack[sp] -= 1;}
    | END       {printf("%d\n", stack[sp]);}

%%

int main() {
    yyparse();
    return 0;
}

int yyerror(char *s) {
    fprintf(stderr, "Error: %s\n", s);
    return 0;
}
