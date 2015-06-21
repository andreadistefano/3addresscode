%{
    #include "3ac.tab.h"
%}

%option noyywrap

%%

0|[1-9][0-9]*           {
                            yylval.val_type.intval = atoi(yytext);
                            yylval.val_type.type = strdup("integer");
                            return VAL;
                        }

(0|[1-9][0-9]*)\.[0-9]+ {
                            yylval.val_type.realval = atof(yytext);
                            yylval.val_type.type = strdup("real");
                            return VAL;
                        }

[a-z]                   {
                            yylval.str = strdup(yytext);
                            return ID;
                        }

"=="                    {
                            yylval.str = strdup(yytext);
                            return EQUAL;
                        }

"!="                    {
                            yylval.str = strdup(yytext);
                            return NOTEQUAL;
                        }

">"                     {
                            yylval.str = strdup(yytext);
                            return GREATER;
                        }

">="                    {
                            yylval.str = strdup(yytext);
                            return GREATEQ;
                        }

"<"                     {
                            yylval.str = strdup(yytext);
                            return LESSER;
                        }

"<="                    {
                            yylval.str = strdup(yytext);
                            return LESSEQ;
                        }

":="                    {
                            yylval.str = strdup(yytext);
                            return ASSIGN;
                        }

"AND"|"&&"              {
                            yylval.str = strdup(yytext);
                            return AND;
                        }

"OR"|"||"               {
                            yylval.str = strdup(yytext);
                            return OR;
                        }

"NOT"|"!"               {
                            yylval.str = strdup(yytext);
                            return NOT;
                        }

"+"                      {
                            yylval.chr = yytext[0];
                            return PLUS;
                        }

"-"                     {
                            yylval.chr = yytext[0];
                            return MINUS;
                        }

"*"                     {
                            yylval.chr = yytext[0];
                            return TIMES;
                        }

"/"                     {
                            yylval.chr = yytext[0];
                            return DIVIDE;
                        }

"("                     {
                            yylval.chr = yytext[0];
                            return LEFT;
                        }

")"                     {
                            yylval.chr = yytext[0];
                            return RIGHT;
                        }

"true"|"TRUE"           {
                            return TRUE;
                        }

"false"|"FALSE"         {
                            return FALSE;
                        }

"\n"                    {
                            return END;
                        }

[ \t]+                  /* ignore whitespace */

.                       {
                            return yytext[0];
                        }


%%