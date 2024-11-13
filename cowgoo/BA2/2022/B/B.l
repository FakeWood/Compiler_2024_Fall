%{
    int isFirst = 1;
%}
%option noyywrap

name        [A-Z]+", "([A-Z][a-z]+)\-([A-Z][a-z]+)
id          [A-Z][12][0-9]{8}
email       [0-9]+@[a-z]+(\.[a-z]+)+
birthday    [0-9]+\/[0-9]+\/[0-9]{2}
phone       \+886[0-9]{9}

%%

{name}        {if(!isFirst) {printf("\n");} isFirst=0; printf("%s\n", yytext);}
{id}          {printf("identity number: %s\n", yytext);}          
{email}       {printf("email: %s\n", yytext);}
{birthday}    {printf("birthday: %s\n", yytext);}
{phone}       {printf("phone: %s\n", yytext);}

%%
int main(int argc, char *argv[]) {
	yylex();
	return(0);
}
