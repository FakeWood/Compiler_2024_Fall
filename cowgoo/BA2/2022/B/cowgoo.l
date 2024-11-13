%{
    #include <stdio.h>
    int start =0;
%}


name [A-Z]+[,][ ][A-Z][a-z]+[-][A-Z][a-z]+
idd [A-Z][12][0-9]{8}
bir     [0-9]{2,4}[/][0-9][0-9][/][0-9][0-9]
phone \+886[0-9]{9}
word     [0-9a-z]+
word2    [a-z]+
email    [ ]*{word}@{word2}(\.{word2})+


%%
{name} {
    
    if(start==0)
    {
        ECHO; 
        printf("\n");
        start =1; 
    }
    else if(start==1)
    {
        printf("\n");
        ECHO; 
        printf("\n");
    }
}

{bir}  {printf("%s","birthday: ");ECHO; printf("\n");}
{idd}  {printf("%s","identity number: ");ECHO; printf("\n");}
{phone}   {printf("%s","phone: ");ECHO;printf("\n");}
{email}    {printf("%s","email: "); ECHO; printf("\n"); }
.
\n

%%

int main(void)
{
    yylex();
    return 0;
}