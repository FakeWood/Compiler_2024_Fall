%{
    #include "string.h"
    int str = 0;
    int validDate();
%}

%option noyywrap
name        [A-Z][a-z]*(\_[A-Z][a-z]*)*
author      [A-Z]+", "[A-Z][a-z]*\-[A-Z][a-z]*
date        [0-9]{4}\/[0-9]{2}\/[0-9]{2}
ISBN        978\-[0-9]\-[0-9]{6}\-[0-9]{2}\-[0-9]
%%

{name}      {if(str == 0) {str = 1; printf("Book name:%s\n", yytext);}}
{author}    {printf("Author:%s\n", yytext);}
{date}      {if(validDate(yytext)) printf("Publication date:%s\n", yytext);}
{ISBN}      {printf("ISBN:%s\n", yytext);}
.           {}
\n          {str = 0;}

%%

int validDate(char* dateStr)
{
    char monthStr[3] = {dateStr[5], dateStr[6], '\0'};
    char dayStr[3] = {dateStr[8], dateStr[9], '\0'};
    int month = atoi(monthStr);
    int day = atoi(dayStr);
    /* printf("MM: %d\nDD: %d\n", month, day); */

    if(month == 2 && day <= 28)
    {
        return 1;
    }
    else if(month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12)
    {
        if(day <= 31) return 1;
    }
    else if(month == 4 || month == 6 || month == 9 || month == 11)
    {
        if(day <= 30) return 1;
    }

    return 0;
}

int main(int argc, char *argv[]) {
    // strlen() — 得到字串長度
    // strcat() — 合併兩個字串
    // strncat(str1（被合併的字串）, str2（原本的字串）, n) — 將str2的前n個字母合併到str1上
	// strcpy(str2, str1) — 複製字串
    // strncpy(str1, str2, n) — 從第str2中的前n個字母複製到str1上
    // strchr(str1, c) — 回傳字母 c 在str1上的哪一個位置
    // atoi ， ACSII convert to integer
    // atof ， ACSII convert to float
    yylex();
	return(0);
}