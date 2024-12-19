%{
#define STACK_SIZE 20

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

int curTrain = 0;

int isEmpty(); // to check if the stack is empty
void push(int i);
int pop();
int top();
void dump(); // to dump (or print) all the data in stack
%}

%union {
int ival;
}

%token END
%token <ival> NUM

%%

program: nums END  {    if(isEmpty()) {
                            printf("Success\n");
                        }
                        else {
                            printf("Error: There is still existing trains in the holding track\n");
                        }
                   }
;

nums: nums num
    | num

num: NUM      {   while(1) {
                        if (!isEmpty() && top() > $1) {
                            printf("Error: Impossible to rearrange\n");
                            printf("The first train in the holding track is train %d instead of train %d", top(), $1);
                            exit(0);
                        }
                        if(isEmpty() && curTrain > $1) {
                            printf("Error: Impossible to rearrange\n");
                            printf("There is no any train in the holding track\n");
                            exit(0);
                        }
                        if (top() == $1) {
                            printf("Moving train %d from holding track\n", pop());
                            break;
                        }
                        curTrain++;
                        if(curTrain == $1) {
                            printf("Train %d passing through\n", $1);
                            break;
                        }
                        printf("Push train %d to holding track\n", curTrain);
                        push(curTrain);
                        dump();       
                    }
                }
;

%%

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

void push(int i) {
    myStack.data[++myStack.top] = i;
}

int pop() {
    return myStack.data[myStack.top--];
}

int top() {
    return myStack.data[myStack.top];
}

void dump() {
    printf("Current holding track:");
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