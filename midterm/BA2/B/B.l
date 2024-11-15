%{
    int inComment = 0;
    int curTab = 0;
%}
%option noyywrap
%%

"#"                {if(!inComment) {printf("//"); inComment = 2;} else ECHO;}
"\"\"\""           {if(!inComment) {printf("/*"); inComment = 1;} else if(inComment == 1) {printf("*/"); inComment = 0;}}
"print("[^\n]*")"  {if(!inComment) {printf("cout << "); for(int i=6; i<yyleng-1; i++) {printf("%c", yytext[i]);} printf(" << endl;");} else printf("%s",yytext);}
" << endl;"        {if(!inComment) printf(")"); else printf("%s",yytext);}
"if True:"         {if(!inComment) {printf("if(true) {");  curTab++;} else printf("%s",yytext);}
"if False:"        {if(!inComment) {printf("if(false) {"); curTab++;} else printf("%s",yytext);}
^[\t]+             {if(inComment == 1){ECHO;} else if(inComment == 2){ECHO; inComment = 0;} else if(yyleng < curTab){while(curTab > yyleng){for(int i=0; i<curTab-1; i++){printf("\t");} printf("}\n"); curTab--;} ECHO;} else ECHO;}
^[\n\r]            {if(inComment == 1){ECHO;} else if(inComment == 2){ECHO; inComment = 0;} else if(curTab-1 == 0){for(int i=0; i<yyleng-1; i++){printf("\t");} printf("}\n\n"); curTab--;} else ECHO;}
[\n\r][\t]*        {if(inComment == 1){ECHO;} else if(inComment == 2){ECHO; inComment = 0;} else if(yyleng-1 < curTab){printf("\n");while(curTab > yyleng-1){for(int i=0; i<curTab-1; i++){printf("\t");} printf("}\n"); curTab--;}for(int i=1; i<yyleng;i++) printf("\t");} else ECHO;}
%%
int main(int argc, char *argv[]) {
	yylex();
	return(0);
}
