%{
#include <stdio.h>
#include <stdlib.h>

int stack[100];
int sp = -1;
int tmp1;
int tmp2;

int yylex();
void yyerror(const char *s);

void showStack() {
    for (int i = 0; i <= sp; i++) printf("stack[%d]: %d\n", i, stack[i]);
}

void push(int a) {
    stack[++sp] = a;
}

int pop() {
    if (sp-1 < -1) yyerror("");
    return stack[sp--];
}

%}

%union {
int ival;
}

%token <ival> NUM
%token LOAD
%token ADD SUB MUL MOD
%token INC DEC

%%

program: lines
;

lines: lines line
     | line
;

line: LOAD NUM  {push($2);}// printf("stack[%d]: %d", sp, stack[sp]);}
    | ADD       {tmp1 = pop(); tmp2 = pop(); push(tmp1 + tmp2);}// printf("stack[%d]: %d", sp, stack[sp]);}
    | SUB       {tmp1 = pop(); tmp2 = pop(); push(tmp1 - tmp2);}// printf("stack[%d]: %d", sp, stack[sp]);}
    | MUL       {tmp1 = pop(); tmp2 = pop(); push(tmp1 * tmp2);}// printf("stack[%d]: %d", sp, stack[sp]);}
    | MOD       {tmp1 = pop(); tmp2 = pop(); if(tmp2 == 0) yyerror(""); else push(tmp1 % tmp2);}// printf("stack[%d]: %d\n", sp, stack[sp]);}
    | INC       {stack[sp] += 1;}
    | DEC       {stack[sp] -= 1;}
;
%%

void yyerror(const char *s) {
    printf("Invalid format\n");
    exit(0);
    return;
}

int main() {
    yyparse();
    if (sp == 0)
        printf("%d\n", stack[sp]);
    else
        printf("Invalid format\n");
    return 0;
}