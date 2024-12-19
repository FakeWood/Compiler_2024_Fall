%{
#include <stdio.h>
#include <stdlib.h>

int yylex();
void yyerror(const char *s);

%}

%union {
double fval;
}

%token <fval> NUM

%type <fval> func

%%

program: func    {printf("%.3f", $1);}
;

func: 'f' '(' func ')'                     {$$ = 4 * $3 - 1;}
    | 'g' '(' func ',' func ')'            {$$ = 2 * $3  + $5 - 5;}
    | 'h' '(' func ',' func ',' func ')'   {$$ = 3 * $3 - 5 * $5 + $7;}
    | NUM                                  {$$ = $1;}
;
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