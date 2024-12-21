%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <map>
#include <iostream>

using namespace std;

int useLog = 0;
int step = 0; 
struct variable {
    int type;
    int val;
};
map<string, variable> var_map;

int yylex();
void yyerror(const char *s);

void reduce(const char *s);

%}

%union {
int ival;
struct {
    int type;
    int val;
    char *name;
    int retType;
} unit;
}

%token PRINT_NUM PRINT_BOOL
%token <unit> NUM BOOL
%token MOD AND OR NOT
%token DEF FUNC IF
%token <unit> ID

%type <unit> expr exprs
%type <unit> num_op
%type <unit> plus_exprs mul_exprs
%type <unit> plus minus mul div mod greater smaller equal
%type <unit> logical_op
%type <unit> and_exprs or_exprs
%type <unit> and_op or_op not_op
%type <unit> func_expr func_call
%type <unit> if_expr test_expr then_expr else_expr
%type <unit> var
%type <unit> ids

%%

program : stmts
;

/* --- all statement--- */
stmts : stmts stmt  {reduce("stmts stmt -> stmts\n");}
      | stmt        {reduce("stmt -> stmts\n");}
;

stmt : expr       {reduce("expr -> stmt\n");}
     | def_stmt   {reduce("def_stmt -> stmt\n");}
     | print_stmt {reduce("print_stmt -> stmt\n");}
;

print_stmt : '(' PRINT_NUM expr ')'     { if($3.type != NUM){ yyerror("type"); } else { printf("%d\n", $3.val); } }
           | '(' PRINT_BOOL expr ')'    { if($3.type != BOOL){ yyerror("type"); } else { printf("#%c\n", ($3.val == 1 ? 't' : 'f')); } }
;
/* --- all statement--- */

/* --- all expression--- */
exprs : exprs expr  {reduce("exprs expr -> exprs\n");}
      | expr        {reduce("expr -> exprs\n");}
;

expr : BOOL          { $$ = $1; reduce("BOOL -> expr\n");}
     | NUM           { $$ = $1; reduce("NUM -> expr\n");}
     | var           { $$ = $1; reduce("var -> expr\n");}
     | num_op        { $$ = $1; reduce("num_op -> expr\n");}
     | logical_op    { $$ = $1; reduce("logical_op -> expr\n");}
     | func_expr     { $$ = $1; reduce("func_expr -> expr\n");}
     | func_call     { $$ = $1; reduce("func_call -> expr\n");}
     | if_expr       { $$ = $1; reduce("if_expr -> expr\n");}
;

plus_exprs : plus_exprs expr    { if($2.type != NUM){ yyerror("type"); } else { $$.type = NUM; $$.val = $1.val + $2.val; } }
           | expr               { if($1.type != NUM){ yyerror("type"); } else { $$ = $1; } }
;

mul_exprs : mul_exprs expr  { if($2.type != NUM){ yyerror("type"); } else { $$.type = NUM; $$.val = $1.val * $2.val; } }
          | expr            { if($1.type != NUM){ yyerror("type"); } else { $$ = $1; } }
;

and_exprs : and_exprs expr  { if($2.type != BOOL){ yyerror("type"); } else { $$.type = BOOL; $$.val = $1.val && $2.val; } }
          | expr            { if($1.type != BOOL){ yyerror("type"); } else { $$ = $1; } }
;

or_exprs : or_exprs expr  { if($2.type != BOOL){ yyerror("type"); } else { $$.type = BOOL; $$.val = $1.val || $2.val; } }
         | expr            { if($1.type != BOOL){ yyerror("type"); } else { $$ = $1; } }
;
/* --- all expression--- */

/* --- number operation --- */
num_op : plus       { $$ = $1; }
       | minus      { $$ = $1; }
       | mul        { $$ = $1; }
       | div        { $$ = $1; }
       | mod        { $$ = $1; }
       | greater    { $$ = $1; }
       | smaller    { $$ = $1; }
       | equal      { $$ = $1; }
;

plus : '(' '+' expr plus_exprs ')'  { if($3.type != NUM){ yyerror("type"); } else { $$.type = NUM; $$.val = $3.val + $4.val; } }
;

minus : '(' '-' expr expr ')'       { if($3.type != NUM || $4.type != NUM){ yyerror("type"); } else { $$.type = NUM; $$.val = $3.val - $4.val; } }
;

mul : '(' '*' expr mul_exprs ')'    { if($3.type != NUM){ yyerror("type"); } else { $$.type = NUM; $$.val = $3.val * $4.val; } }
;

div : '(' '/' expr expr ')'         { if($3.type != NUM || $4.type != NUM){ yyerror("type"); } else { $$.type = NUM; $$.val = $3.val / $4.val; } }
;

mod : '(' MOD expr expr ')'         { if($3.type != NUM || $4.type != NUM){ yyerror("type"); } else { $$.type = NUM; $$.val = $3.val % $4.val; } }
;

greater : '(' '>' expr expr ')'     { if($3.type != NUM || $4.type != NUM){ yyerror("type"); } else { $$.type = BOOL; $$.val = $3.val > $4.val; } }
;

smaller : '(' '<' expr expr ')'     { if($3.type != NUM || $4.type != NUM){ yyerror("type"); } else { $$.type = BOOL; $$.val = $3.val < $4.val; } }
;

equal : '(' '=' expr expr ')'       { if($3.type != NUM || $4.type != NUM){ yyerror("type"); } else { $$.type = BOOL; $$.val = $3.val == $4.val; } }
;
/* --- number operation --- */

/* --- logical operation --- */
logical_op : and_op                 { $$ = $1; }
           | or_op                  { $$ = $1; }
           | not_op                 { $$ = $1; }
;

and_op : '(' AND expr and_exprs ')'     { if($3.type != BOOL){ yyerror("type"); } else { $$.type = BOOL; $$.val = $3.val && $4.val; } }
;

or_op : '(' OR expr or_exprs ')'        { if($3.type != BOOL){ yyerror("type"); } else { $$.type = BOOL; $$.val = $3.val || $4.val; } }
;

not_op : '(' NOT expr ')'               { if($3.type != BOOL){ yyerror("type"); } else { $$.type = BOOL; $$.val = !$3.val; } }
;
/* --- logical operation --- */

/* --- define --- */
def_stmt : '(' DEF var expr ')'     { printf("var: %s\n", $3.name); if(var_map.count(string($3.name)) != 0){ printf("ERROR: re-define var\n"); } else { var_map[string($3.name)] = {$4.type, $4.val}; } }// printf("%s: %d\n", $3.name, $4.val);} }
;

var : ID                            { if(var_map.count(string($1.name)) == 0) { string tmp = string($1.name); strcpy($$.name, tmp.c_str()); } else { $$.type = var_map[string($1.name)].type; $$.val = var_map[string($1.name)].val; } printf("ID: %s\n", $$.name);}
;
/* --- define --- */

/* --- function --- */
func_expr : '(' FUNC func_ids func_body ')'  {}
;

func_ids : '(' ids ')'      {}
         | '(' ')'          {}
;

ids : ids ID        {}
    | ID            {}
;

func_body : expr    {}
;

func_call : '(' func_expr params ')'        {}
          | '(' func_expr ')'               {}
          | '(' func_name params ')'        {}
          | '(' func_name ')'               {}
;

params : exprs
;

func_name : ID
;
/* --- function --- */

/* --- if --- */
if_expr : '(' IF test_expr then_expr else_expr ')'  { if($3.type != BOOL){ yyerror("type"); } else { if($3.val){ $$ = $4; } else { $$ = $5; } } }
;

test_expr : expr
;

then_expr : expr    { $$ = $1; }
;

else_expr : expr    { $$ = $1; }
;
/* --- if --- */

%%

void reduce(const char *s) {
    if(useLog) printf("reduce: %s\n", s);
}


void yyerror(const char *s) {
    if(strcmp(s, "type") == 0) {
        printf("Type error!");
    }
    else {
        printf("syntax error");
    }
    exit(1);
    return;
}

int main() {
    yyparse();

    /* for(auto i : var_map) {
        cout << i.first << ": " << i.second.val << "\n";
    } */

    return 0;
}