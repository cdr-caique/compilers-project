win_bison -d parser.y
win_flex lexer.l
gcc parser.tab.c lex.yy.c -o program.exe
pause