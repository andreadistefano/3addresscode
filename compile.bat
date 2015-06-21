@echo off

flex 3ac.l
bison -d 3ac.y
IF "%~1"=="" gcc 3ac.tab.c
IF "%~1"=="-d" gcc -g 3ac.tab.c