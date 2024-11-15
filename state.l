/*state

%{
%}

%x STATE1 //定義STATE1

%% //rules

[reg...] { BEGIN STATE1; }//進入STATE1
<STATE1>[此reg只試用於STATE1...] {...}
<STATE1>[reg...] {BEGIN 0;}//離開STATE1

%%

*/
printf("yyleng: %d, curTab: %d\n", yyleng, curTab);