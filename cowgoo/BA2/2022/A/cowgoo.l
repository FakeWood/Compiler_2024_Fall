%{
#include<stdio.h>
int i=0;
int startmul =0;
int startif = 0;
int indexs = 0;
%}
%option noyywrap

mulcomleft [\t]*[/][\*]
mulcomright [\t]*[\*][/]
singlecom [\t]*[/][/][^\n]*
pri ^[\t]*cout.*
iff ^[\t]*if.*
endif ^[\t]*\}
eol \n
other .*


%%

{mulcomleft} {
     for(indexs=0;indexs<yyleng;indexs++)
    {
         if(yytext[indexs]!='\t')
        {
               break;
        }
        printf("%c",yytext[indexs]);
    }
    printf("\"\"\"");
    startmul = 1;
}
{mulcomright} {
     for(indexs=0;indexs<yyleng;indexs++)
    {
         if(yytext[indexs]!='\t')
        {
               break;
        }
        printf("%c",yytext[indexs]);
    }
    printf("\"\"\"");
    startmul = 0;
}
{singlecom} {
    for(indexs=0;indexs<yyleng;indexs++)
    {
         if(yytext[indexs]!='\t')
        {
               break;
        }
        printf("%c",yytext[indexs]);
    }
    printf("# ");
    for(i=indexs+3;i<yyleng;i++)
    {
        printf("%c",yytext[i]);
    }
}
{pri} {
    if(startmul==1)
    {
        for(indexs=0;indexs<yyleng;indexs++)
        {
            printf("%c",yytext[indexs]);
        }
    }
    else{
        for(indexs=0;indexs<yyleng;indexs++)
        {
            if(yytext[indexs]!='\t')
            {
               break;
            }
            printf("%c",yytext[indexs]);
        }
        printf("print(");
        for(i=indexs+8;i<yyleng-9;i++)
        {   
            printf("%c",yytext[i]);
        }
        printf(")");
    }
    
}
{iff} {
    if(startmul==1)
    {
        for(indexs=0;indexs<yyleng;indexs++)
        {
            printf("%c",yytext[indexs]);
        }
    }
    else
    {
        for(indexs=0;indexs<yyleng;indexs++)
        {
            if(yytext[indexs]!='\t')
            {
               break;
            }
            printf("%c",yytext[indexs]);
        }
        printf("if ");
        indexs+=3;
        if(yytext[indexs]=='t')
        {
            printf("T");
        }
        else if(yytext[indexs]=='f')
        {
            printf("F");
        }
        for(i=indexs+1;i<yyleng-3;i++)
        {
            printf("%c",yytext[i]);
        }
        printf(":");
        startif = 1;
    }
    
}
{endif} {
    if(startmul==1)
    {
        for(indexs=0;indexs<yyleng;indexs++)
        {
            if(yytext[indexs]!='\t')
            {
               break;
            }
            printf("%c",yytext[indexs]);
        }
        printf("}");
    }
    else if(startif ==1)
    {
        startif =0;
    }
    //printf("\n");
}
{other} {
    if(startmul == 1)
    {
        if(startif == 0 )
        {
             for(i=0;i<yyleng;i++)
             {
                  printf("%c",yytext[i]);
            }
        }
        else
        {
            //printf("\t");
             for(i=0;i<yyleng;i++)
             {
                 printf("%c",yytext[i]);
             }
        }
        
    }
    else if(startif ==1)
    {
        //printf("\t");
        for(i=0;i<yyleng;i++)
        {
            printf("%c",yytext[i]);
        }
    }
}
{eol} {
    printf("\n");
}

%%

int main(void)
{
    //2022_BA2_Code_Transformation
    yylex();
    return 0;
}
