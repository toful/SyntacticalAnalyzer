#!/bin/bash

bison -d FASyntacticAnalyzer.y
flex FALexicalAnalyzer.l
cc lex.yy.c FASyntacticAnalyzer.tab.c -lfl
