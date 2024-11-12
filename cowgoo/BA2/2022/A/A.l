%{
    int inComment = 0;
%}
%option noyywrap
%%

"//"               {printf("#"); if(!inComment) inComment = 2;}
"/*"               {printf("\"\"\""); inComment = 1;}
"*/"               {printf("\"\"\""); inComment = 0;}
"cout << "         {if(!inComment) printf("print("); else printf("%s",yytext);}
" << endl;"        {if(!inComment) printf(")"); else printf("%s",yytext);}
"if(true) {"       {if(!inComment) printf("if True:"); else printf("%s",yytext);}
"if(false) {"      {if(!inComment) printf("if False:"); else printf("%s",yytext);}
[ \t]*"}\n"        {if(inComment) printf(yytext);}  
"\n"               {printf("\n"); if(inComment == 2) inComment = 0;}

%%
int main(int argc, char *argv[]) {
	yylex();
	return(0);
}
