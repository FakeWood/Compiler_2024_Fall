%{
	int ident = 0;
%}
%option noyywrap
%%
\"[^\n]\"           {printf("%s", yytext);}
\'[^\n]\'           {printf("%s", yytext);}
"{"                 {ident++; printf("{");}
"}"                 {ident--; printf("}");}
"\n"                {printf("\n"); for (int i=0; i<ident; i++) {printf("\t");}}
"\n}"               {ident--; printf("\n"); for (int i=0; i<ident; i++) {printf("\t");} printf("}");}
"\n{"               {ident++; printf("\n"); for (int i=0; i<ident-1; i++) {printf("\t");} printf("{");}
"\t"                {}
%%
int main(int argc, char *argv[]) {
	yylex();
	return(0);
}
