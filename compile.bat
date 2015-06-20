@echo off

flex 3ac.l
bison -d 3ac.y
gcc 3ac.tab.c