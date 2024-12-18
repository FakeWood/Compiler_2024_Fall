%{
#define STACK_SIZE 10

#include <stdio.h>
#include <stdlib.h>

int yylex();
void yyerror(const char* message);

struct stack {
int data[STACK_SIZE];
int top;
};

typedef struct stack stack_t;
stack_t myStack;

int isEmpty(); // to check if the stack is empty
int isFull(); // to check if the stack is full
void push(int i);
int pop();
void dump(); // to dump (or print) all the data in stack
void re_pop();
void re_push();
%}

%union {
int ival;
}

%token <ival> NUM

%%

program: exprs
;

exprs: exprs expr
     | expr   {}
;

expr : '+'    {if (isEmpty()){ re_pop(); YYABORT;} int a = pop(); if (isEmpty()) { re_pop(); YYABORT;} int b = pop(); push(b + a); dump();}
     | '-'    {if (isEmpty()){ re_pop(); YYABORT;} int a = pop(); if (isEmpty()) { re_pop(); YYABORT;} int b = pop(); push(b - a); dump();}
     | '*'    {if (isEmpty()){ re_pop(); YYABORT;} int a = pop(); if (isEmpty()) { re_pop(); YYABORT;} int b = pop(); push(b * a); dump();}
     | '/'    {if (isEmpty()){ re_pop(); YYABORT;} int a = pop(); if (isEmpty()) { re_pop(); YYABORT;} int b = pop(); push(b / a); dump();}
     | NUM    {if (isFull()){ re_push(); YYABORT;} push($1); dump();}
;

%%

void re_pop() {
    printf("Runtime Error: The pop will lead to stack underflow.\n");
}

void re_push() {
    printf("Runtime Error: The push will lead to stack overflow.\n");
}

void yyerror(const char *s) {
    printf("Invalid Value");
    exit(0);
    return;
}

int isEmpty() {
    if (myStack.top < 0)
        return 1;
    else 
        return 0;
}

int isFull() {
    if (myStack.top >= STACK_SIZE - 1)
        return 1;
    else 
        return 0;
}

void push(int i) {
    myStack.data[++myStack.top] = i;
}

int pop() {
    return myStack.data[myStack.top--];
}

void dump() {
    printf("The contents of the stack are:");
    for (int i=0; i<=myStack.top; i++) {
        printf(" %d", myStack.data[i]);
    }
    printf("\n");
}

int main() {
    myStack.top = -1;
    yyparse();
    return 0;
}