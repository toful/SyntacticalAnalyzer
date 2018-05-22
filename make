#!/bin/bash
flex FALexicalAnalyzer.l
bison -t -d -v FASyntacticAnalyzer.y
gcc lex.yy.c FASyntacticAnalyzer.tab.c -lfl

