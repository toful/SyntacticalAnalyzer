#!/bin/bash
flex FALexicalAnalyzer.l
bison -t -d -v FASyntacticAnalyzer.y
cc lex.yy.c FASyntacticAnalyzer.tab.c -lfl

