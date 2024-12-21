#!/bin/bash

# 編譯 Lex 檔案
flex miniLISP.l

# 編譯 Yacc 檔案
bison -d miniLISP.y

# 編譯並連結
gcc lex.yy.c miniLISP.tab.c

# 成功訊息
echo "Compilation complete."

# 刪中間檔案
rm lex.yy.c *.tab.*
echo "Intermediate files deleted"

# 檢查是否有提供測試參數
if [ "$#" -eq 1 ]; then
  ./a.exe < public_test_data/"$1".lsp > out
  diff -y public_test_output/"$1".out out
fi