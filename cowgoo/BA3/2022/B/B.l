%{
#include "string.h"
#include "B.tab.h"
%}

%option noyywrap

%%

"<and>"        {return AND_S;}
"</and>"       {return AND_E;}
"<or>"         {return OR_S;}
"</or>"        {return OR_E;}
"<not>"        {return NOT_S;}
"</not"        {return NOT_E;}
"<true/>"      {return T;}
"<false/>"     {return F;}
"\n"|"t"|" "   {}
.              {}

%%