%{
#include <stdio.h>
#include <stdlib.h>

int yylex();
void yyerror(const char *s);

%}

%union {
int ival;
char *str;
}

%token PRINT_NUM PRINT_BOOL
%token NUM BOOL
%token MOD AND OR NOT
%token DEF FUNC IF
%token <str> ID

%%

program : stmts
;

/* --- all statement--- */
stmts : stmts stmt
      | stmt
;

stmt : expr
     | def_stmt
     | print_stmt
;

print_stmt : '(' PRINT_NUM expr ')'
           | '(' PRINT_BOOL expr ')'
;

exprs : exprs expr
      | expr

expr : BOOL
     | NUM
     | var
     | num_op
     | logical_op
     | func_expr
     | func_call
     | if_expr
;
/* --- all statement--- */

/* --- number operation --- */
num_op : plus
       | minus
       | mul
       | div
       | mod
       | greater
       | smaller
       | equal
;

plus : '(' '+' expr exprs ')'
;

minus : '(' '-' expr expr')'
;

mul : '(' '*' expr exprs')'
;

div : '(' '/' expr expr')'
;

mod : '(' MOD expr expr ')'
;

greater : '(' '>' expr expr')'
;

smaller : '(' '<' expr expr')'
;

equal : '(' '=' expr expr')'
;
/* --- number operation --- */

/* --- logical operation --- */
logical_op : and_op
           | or_op
           | not_op
;

and_op : '(' AND expr exprs ')'
;

or_op : '(' OR expr exprs ')'
;

not_op : '(' NOT expr ')'
;
/* --- logical operation --- */

/* --- define --- */
def_stmt : '(' DEF var expr ')'
;

var : ID
;
/* --- define --- */

/* --- function --- */
func_expr : '(' FUNC func_ids func_body ')'
;

func_ids : '(' ids ')'
         | '(' ')'
;

ids : ids ID
    | ID
;

func_body : expr
;

func_call : '(' func_expr params ')'
          | '(' func_expr ')'
          | '(' func_name params ')'
          | '(' func_name ')'
;

params : exprs
;

func_name : ID
;
/* --- function --- */

/* --- if --- */
if_expr : '(' IF test_expr then_expr else_expr ')'
;

test_expr : expr
;

then_expr : expr
;

else_expr : expr
;
/* --- if --- */

%%

void yyerror(const char *s) {
    printf("Invalid\n");
    exit(0);
    return;
}

int main() {
    yyparse();

    return 0;
}