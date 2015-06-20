%{
    #include <stdio.h>
    #include <ctype.h>
    #include <string.h>
    #include "lex.yy.c"

    #define YYDEBUG 1

    int nextstat = 100;
    int count = 1;
    char s[5];
    int temp1, temp2;

    void newtemp (char *s, int i) {
        sprintf(s, "t%d", i);
        count++;
    }

%}

%union {
    char *str;
    char chr;
    int integer;
    double real;
}

%token <integer> VAL
%token <str> ID GREATER LESSER GREATEQ LESSEQ EQUAL NOTEQUAL AND OR NOT ASSIGN TRUE FALSE
%token <chr> PLUS MINUS TIMES DIVIDE POWER LEFT RIGHT END
%type <str> e

%left OR
%left AND
%nonassoc GREATER GREATEQ LESSER LESSEQ EQUAL NOTEQUAL
%left PLUS MINUS
%left TIMES DIVIDE
%left NEG NOT

%start s

%%

s : e                   {
                            return 0;
                        }

s : ID ASSIGN e END     {
                            printf("%d\t%s := %s\n", nextstat++, $1, $3);
                            return 0;
                        };

e : e PLUS e            {
                            newtemp(s, count);
                            $$ = strdup(s);
                            printf("%d\t%s := %s %c %s\n", nextstat++, $$, $1, $2, $3);
                        };

e : e MINUS e           {
                            newtemp(s, count);
                            $$ = strdup(s);
                            printf("%d\t%s := %s %c %s\n", nextstat++, $$, $1, $2, $3);
                        };

e : e TIMES e           {
                            newtemp(s, count);
                            $$ = strdup(s);
                            printf("%d\t%s := %s %c %s\n", nextstat++, $$, $1, $2, $3);
                        };

e : e DIVIDE e          {
                            newtemp(s, count);
                            $$ = strdup(s);
                            printf("%d\t%s := %s %c %s\n", nextstat++, $$, $1, $2, $3);
                        };

e : MINUS e %prec NEG   {
                            newtemp(s, count);
                            $$ = strdup(s);
                            printf ("%d\t%s := %c%s\n", nextstat++, $$, $1, $2);
                        };

e : LEFT e RIGHT        {
                            $$ = strdup($2);
                        };

e : ID                  {
                            $$ = strdup($1);
                        };

e : VAL                 {
                            char p[256] = "";
                            sprintf(p, "%d", $1);
                            $$ = strdup(p);
                            temp1 = $1;
                        }

e : e AND e             {
                            newtemp(s, count);
                            $$ = strdup(s);
                            printf ("%d\t%s := %s AND %s\n", nextstat++, $$, $1, $3);
                        };

e : e OR e              {
                            newtemp(s, count);
                            $$ = strdup(s);
                            printf ("%d\t%s := %s OR %s\n", nextstat++, $$, $1, $3);
                        };

e : NOT e               {
                            newtemp(s, count);
                            $$ = strdup(s);
                            printf ("%d\t%s := NOT %s\n", nextstat++, $$, $2);
                        };

e : e GREATER e         {
                            newtemp(s, count);
                            $$ = strdup(s);
                            printf("%d\tif %s %s %s goto %d\n", nextstat, $1, $2, $3, nextstat + 3);
                            nextstat++;
                            printf("%d\t%s := 0\n", nextstat++, $$);
                            printf("%d\tgoto %d\n", nextstat, nextstat + 2);
                            nextstat++;
                            printf("%d\t%s := 1\n", nextstat++, $$);
                        };

e : e LESSER e          {
                            newtemp(s, count);
                            $$ = strdup(s);
                            printf("%d\tif %s %s %s goto %d\n", nextstat, $1, $2, $3, nextstat + 3);
                            nextstat++;
                            printf("%d\t%s := 0\n", nextstat++, $$);
                            printf("%d\tgoto %d\n", nextstat, nextstat + 2);
                            nextstat++;
                            printf("%d\t%s := 1\n", nextstat++, $$);
                        };

e : e GREATEQ e         {
                            newtemp(s, count);
                            $$ = strdup(s);
                            printf("%d\tif %s %s %s goto %d\n", nextstat, $1, $2, $3, nextstat + 3);
                            nextstat++;
                            printf("%d\t%s := 0\n", nextstat++, $$);
                            printf("%d\tgoto %d\n", nextstat, nextstat + 2);
                            nextstat++;
                            printf("%d\t%s := 1\n", nextstat++, $$);
                        };

e : e LESSEQ e          {
                            newtemp(s, count);
                            $$ = strdup(s);
                            printf("%d\tif %s %s %s goto %d\n", nextstat, $1, $2, $3, nextstat + 3);
                            nextstat++;
                            printf("%d\t%s := 0\n", nextstat++, $$);
                            printf("%d\tgoto %d\n", nextstat, nextstat + 2);
                            nextstat++;
                            printf("%d\t%s := 1\n", nextstat++, $$);
                        };

e : e EQUAL e           {
                            newtemp(s, count);
                            $$ = strdup(s);
                            printf("%d\tif %s %s %s goto %d\n", nextstat, $1, $2, $3, nextstat + 3);
                            nextstat++;
                            printf("%d\t%s := 0\n", nextstat++, $$);
                            printf("%d\tgoto %d\n", nextstat, nextstat + 2);
                            nextstat++;
                            printf("%d\t%s := 1\n", nextstat++, $$);
                        };

e : e NOTEQUAL e        {
                            newtemp(s, count);
                            $$ = strdup(s);
                            printf("%d\tif %s %s %s goto %d\n", nextstat, $1, $2, $3, nextstat + 3);
                            nextstat++;
                            printf("%d\t%s := 0\n", nextstat++, $$);
                            printf("%d\tgoto %d\n", nextstat, nextstat + 2);
                            nextstat++;
                            printf("%d\t%s := 1\n", nextstat++, $$);
                        };

e : TRUE                {
                            newtemp(s, count);
                            $$ = strdup(s);
                            printf("%d\t%s := 1\n", nextstat++, $$);
                        }

e : FALSE               {
                            newtemp(s, count);
                            $$ = strdup(s);
                            printf("%d\t%s := 0\n", nextstat++, $$);
                        }

%%

main() {
    yyparse();
}

yyerror (char *s) {
    fprintf(stderr, "%s\n", s);
}