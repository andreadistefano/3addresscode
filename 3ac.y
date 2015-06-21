%{
    #include <stdio.h>
    #include <ctype.h>
    #include <string.h>
    #include <math.h>
    #include "lex.yy.c"

    int nextstat = 100;
    int count = 1;
    char s[5];
    int dividebyzero;

    void newtemp (char *s, int i) {
        sprintf(s, "t%d", i);
        count++;
        return;
    }

    void int_to_real (struct val_type *e) {
        e->type = strdup("real");
        e->realval = (double) e->intval;
        return;
    }

    int is_int (struct val_type e) {
        return e.type != NULL && strcmp(e.type, "integer") == 0;
    }

    int is_real (struct val_type e) {
        return e.type != NULL && strcmp(e.type, "real") == 0;
    }

    int is_boolean (struct val_type e) {
        return e.type != NULL && strcmp(e.type, "boolean") == 0;
    }

    int is_void (struct val_type e) {
        return e.type != NULL && strcmp(e.type, "void") == 0;
    }

    int intpow (int a, int b) {
        int r = 1;
        while (b > 0) {
            r *= a;
            b--;
        }
        return r;
    }

    void eval (struct val_type *e, struct val_type e1, char op, struct val_type e2) {
        if ( (is_real(e1) && is_real(e2)) || (is_int(e1) && is_real(e2)) || (is_real (e1) && is_int (e2)) ) {
            if (is_int(e1)) int_to_real(&e1);
            else if (is_int(e2)) int_to_real(&e2);
            e->type = strdup("real");
            switch (op) {
                case '+':
                    e->realval = e1.realval + e2.realval;
                    break;
                case '-':
                    e->realval = e1.realval - e2.realval;
                    break;
                case '*':
                    e->realval = e1.realval * e2.realval;
                    break;
                case '/':
                    if (e2.realval != 0.0) {
                        e->realval = e1.realval / e2.realval;
                    }
                    else {
                        dividebyzero = 1;
                    }
                    break;
                case '^':
                    e->realval = pow(e1.realval, e2.realval);
                    break;
                default:
                    break;
            }
        }
        else if (is_int(e1) && is_int(e2)) {
            e->type = strdup("integer");
            switch (op) {
                case '+':
                    e->intval = e1.intval + e2.intval;
                    break;
                case '-':
                    e->intval = e1.intval - e2.intval;
                    break;
                case '*':
                    e->intval = e1.intval * e2.intval;
                    break;
                case '/':
                    if (e2.intval != 0) {
                        e->intval = e1.intval / e2.intval;
                    }
                    else {
                        dividebyzero = 1;
                    }
                    break;
                case '^':
                    e->intval = intpow(e1.intval, e2.intval);
                    break;
                default:
                    break;
            }
        }
        else if (is_void(e1) || is_void(e2)) {
            e->type = strdup("void");
        }
        else {
            e->type = strdup("type_error");
        }
        return;
    }

    void bool_eval (struct val_type *e, struct val_type e1, char *op, struct val_type e2) {
        if (is_boolean(e1) && is_boolean(e2)) {
            e->type = strdup("boolean");
            if (strcmp(op, "AND") == 0 || strcmp(op, "&&") == 0) {
                e->boolval = e1.boolval && e2.boolval;
            }
            if (strcmp(op, "OR") == 0 || strcmp(op, "||") == 0) {
                e->boolval = e1.boolval || e2.boolval;
            }
        }
        else if (is_void(e1) || is_void (e2)) {
            e->type = strdup("boolean");
        }
        else {
            e->type = strdup("type_error");
        }
        return;
    }

    void relop_eval (struct val_type *e, struct val_type e1, char *relop, struct val_type e2) {
        if ( (is_real(e1) && is_real(e2)) || (is_int(e1) && is_real(e2)) || (is_real (e1) && is_int (e2)) ) {
            if (is_int(e1)) int_to_real(&e1);
            else if (is_int(e2)) int_to_real(&e2);
            e->type = strdup("boolean");
            if (strcmp(relop, "==") == 0) e->boolval = (e1.realval == e2.realval);
            if (strcmp(relop, "!=") == 0) e->boolval = (e1.realval != e2.realval);
            if (strcmp(relop, ">") == 0) e->boolval = (e1.realval > e2.realval);
            if (strcmp(relop, ">=") == 0) e->boolval = (e1.realval >= e2.realval);
            if (strcmp(relop, "<") == 0) e->boolval = (e1.realval > e2.realval);
            if (strcmp(relop, "<=") == 0) e->boolval = (e1.realval >= e2.realval);
        }
        else if (is_int(e1) && is_int(e2)) {
            e->type = strdup("boolean");
            if (strcmp(relop, "==") == 0) e->boolval = (e1.intval == e2.intval);
            if (strcmp(relop, "!=") == 0) e->boolval = (e1.intval != e2.intval);
            if (strcmp(relop, ">") == 0) e->boolval = (e1.intval > e2.intval);
            if (strcmp(relop, ">=") == 0) e->boolval = (e1.intval >= e2.intval);
            if (strcmp(relop, "<") == 0) e->boolval = (e1.intval > e2.intval);
            if (strcmp(relop, "<=") == 0) e->boolval = (e1.intval >= e2.intval);
        }
        else if (is_void(e1) || is_void(e2)) {
            e->type = strdup("boolean");
        }
        else {
            e->type = strdup("type_error");
        }
        return;
    }

    void prettyprint (struct val_type e) {
        if (e.str != NULL && e.type != NULL) {
            printf("\nstr: %s\ntype: %s\nintval: %d\nboolval: %d\nrealval: %f\n\n", e.str, e.type, e.intval, e.boolval, e.realval);
        }
        return;
    }
%}

%union {
    struct val_type {
        char *str;
        char *type;
        int intval;
        int boolval;
        double realval;
    } val_type;
    char *str;
    char chr;
}

%token <val_type> VAL
%token <str> ID GREATER LESSER GREATEQ LESSEQ EQUAL NOTEQUAL AND OR NOT ASSIGN TRUE FALSE
%token <chr> PLUS MINUS TIMES DIVIDE POWER LEFT RIGHT END
%type <val_type> e

%left OR
%left AND
%nonassoc GREATER GREATEQ LESSER LESSEQ EQUAL NOTEQUAL
%left PLUS MINUS
%left TIMES DIVIDE
%right POWER
%left NEG NOT

%start s

%%

s : e                   {
                            if (dividebyzero) {
                                printf("\nRESULT: ERROR. CANNOT DIVIDE BY 0!");
                            }
                            else if (is_int($1)) {
                                printf("\nRESULT: %d (%s)", $1.intval, $1.type);
                            }
                            else if (is_real($1)) {
                                printf("\nRESULT: %f (%s)", $1.realval, $1.type);
                            }
                            else if (is_boolean($1)) {
                                printf("\nRESULT: %d (%s)", $1.boolval, $1.type);
                            }
                            else if (is_void($1)) {
                                printf("\nRESULT: %s (%s)", $1.str, $1.type);
                            }
                            else {
                                printf("\nRESULT: %s (%s)", $1.str, $1.type);
                            }
                            return 0;
                        };

s : ID ASSIGN e END     {
                            printf("%d\t%s := %s\n", nextstat++, $1, $3.str);
                            if (dividebyzero) {
                                printf("\nRESULT: ERROR. CANNOT DIVIDE BY 0!");
                            }
                            else if (is_int($3)) {
                                printf("\nRESULT: %d (%s)", $3.intval, $3.type);
                            }
                            else if (is_real($3)) {
                                printf("\nRESULT: %f (%s)", $3.realval, $3.type);
                            }
                            else if (is_boolean($3)) {
                                printf("\nRESULT: %d (%s)", $3.boolval, $3.type);
                            }
                            else if (is_void($3)) {
                                printf("\nRESULT: %s (%s)", $1, $3.type);
                            }
                            else {
                                printf("\nRESULT: %s (%s)", $1, $3.type);
                            }
                            return 0;
                        };

e : e PLUS e            {
                            struct val_type temp;
                            temp.str = NULL;
                            temp.type = NULL;
                            if ( (is_int($1) && is_real($3)) || is_real($1) && is_int($3) ) {
                                newtemp(s, count);
                                temp.str = strdup(s);
                                temp.type = strdup("real");
                                if (is_int($1)) {
                                    if ($1.str[0] = 't') {
                                        printf("%d\t%s := int_to_real %s\n", nextstat++, s, $1.str);
                                    }
                                    else {
                                        printf("%d\t%s := int_to_real %d\n", nextstat++, s, $1.intval);
                                    }
                                }
                                else {
                                    if ($3.str[0] = 't') {
                                        printf("%d\t%s := int_to_real %s\n", nextstat++, s, $3.str);
                                    }
                                    else {
                                        printf("%d\t%s := int_to_real %d\n", nextstat++, s, $3.intval);
                                    }
                                }
                            }
                            newtemp(s, count);
                            $$.str = strdup(s);
                            if (is_real($1) && is_real($3)) {
                                printf("%d\t%s := %s real%c %s\n", nextstat++, $$.str, $1.str, $2, $3.str);
                            }
                            else if (is_real(temp)) {
                                if (is_int($1)) printf("%d\t%s := %s real%c %s\n", nextstat++, $$.str, temp.str, $2, $3.str);
                                else printf("%d\t%s := %s real%c %s\n", nextstat++, $$.str, $1.str, $2, temp.str);
                            }
                            else {
                                printf("%d\t%s := %s %c %s\n", nextstat++, $$.str, $1.str, $2, $3.str);
                            }
                            eval (&$$, $1, $2, $3);
                        };

e : e MINUS e           {
                            struct val_type temp;
                            temp.str = NULL;
                            temp.type = NULL;
                            if ( (is_int($1) && is_real($3)) || is_real($1) && is_int($3) ) {
                                newtemp(s, count);
                                temp.str = strdup(s);
                                temp.type = strdup("real");
                                if (is_int($1)) {
                                    if ($1.str[0] = 't') {
                                        printf("%d\t%s := int_to_real %s\n", nextstat++, s, $1.str);
                                    }
                                    else {
                                        printf("%d\t%s := int_to_real %d\n", nextstat++, s, $1.intval);
                                    }
                                }
                                else {
                                    if ($3.str[0] = 't') {
                                        printf("%d\t%s := int_to_real %s\n", nextstat++, s, $3.str);
                                    }
                                    else {
                                        printf("%d\t%s := int_to_real %d\n", nextstat++, s, $3.intval);
                                    }
                                }
                            }
                            newtemp(s, count);
                            $$.str = strdup(s);
                            if (is_real($1) && is_real($3)) {
                                printf("%d\t%s := %s real%c %s\n", nextstat++, $$.str, $1.str, $2, $3.str);
                            }
                            else if (is_real(temp)) {
                                if (is_int($1)) printf("%d\t%s := %s real%c %s\n", nextstat++, $$.str, temp.str, $2, $3.str);
                                else printf("%d\t%s := %s real%c %s\n", nextstat++, $$.str, $1.str, $2, temp.str);
                            }
                            else {
                                printf("%d\t%s := %s %c %s\n", nextstat++, $$.str, $1.str, $2, $3.str);
                            }
                            eval (&$$, $1, $2, $3);
                        };

e : e TIMES e           {
                            struct val_type temp;
                            temp.str = NULL;
                            temp.type = NULL;
                            if ( (is_int($1) && is_real($3)) || is_real($1) && is_int($3) ) {
                                newtemp(s, count);
                                temp.str = strdup(s);
                                temp.type = strdup("real");
                                if (is_int($1)) {
                                    if ($1.str[0] = 't') {
                                        printf("%d\t%s := int_to_real %s\n", nextstat++, s, $1.str);
                                    }
                                    else {
                                        printf("%d\t%s := int_to_real %d\n", nextstat++, s, $1.intval);
                                    }
                                }
                                else {
                                    if ($3.str[0] = 't') {
                                        printf("%d\t%s := int_to_real %s\n", nextstat++, s, $3.str);
                                    }
                                    else {
                                        printf("%d\t%s := int_to_real %d\n", nextstat++, s, $3.intval);
                                    }
                                }
                            }
                            newtemp(s, count);
                            $$.str = strdup(s);
                            if (is_real($1) && is_real($3)) {
                                printf("%d\t%s := %s real%c %s\n", nextstat++, $$.str, $1.str, $2, $3.str);
                            }
                            else if (is_real(temp)) {
                                if (is_int($1)) printf("%d\t%s := %s real%c %s\n", nextstat++, $$.str, temp.str, $2, $3.str);
                                else printf("%d\t%s := %s real%c %s\n", nextstat++, $$.str, $1.str, $2, temp.str);
                            }
                            else {
                                printf("%d\t%s := %s %c %s\n", nextstat++, $$.str, $1.str, $2, $3.str);
                            }
                            eval (&$$, $1, $2, $3);
                        };

e : e DIVIDE e          {
                            struct val_type temp;
                            temp.str = NULL;
                            temp.type = NULL;
                            if ( (is_int($1) && is_real($3)) || is_real($1) && is_int($3) ) {
                                newtemp(s, count);
                                temp.str = strdup(s);
                                temp.type = strdup("real");
                                if (is_int($1)) {
                                    if ($1.str[0] = 't') {
                                        printf("%d\t%s := int_to_real %s\n", nextstat++, s, $1.str);
                                    }
                                    else {
                                        printf("%d\t%s := int_to_real %d\n", nextstat++, s, $1.intval);
                                    }
                                }
                                else {
                                    if ($3.str[0] = 't') {
                                        printf("%d\t%s := int_to_real %s\n", nextstat++, s, $3.str);
                                    }
                                    else {
                                        printf("%d\t%s := int_to_real %d\n", nextstat++, s, $3.intval);
                                    }
                                }
                            }
                            newtemp(s, count);
                            $$.str = strdup(s);
                            if (is_real($1) && is_real($3)) {
                                printf("%d\t%s := %s real%c %s\n", nextstat++, $$.str, $1.str, $2, $3.str);
                            }
                            else if (is_real(temp)) {
                                if (is_int($1)) printf("%d\t%s := %s real%c %s\n", nextstat++, $$.str, temp.str, $2, $3.str);
                                else printf("%d\t%s := %s real%c %s\n", nextstat++, $$.str, $1.str, $2, temp.str);
                            }
                            else {
                                printf("%d\t%s := %s %c %s\n", nextstat++, $$.str, $1.str, $2, $3.str);
                            }
                            eval (&$$, $1, $2, $3);
                        };

e : e POWER e           {
                            struct val_type temp;
                            temp.str = NULL;
                            temp.type = NULL;
                            if ( (is_int($1) && is_real($3)) || is_real($1) && is_int($3) ) {
                                newtemp(s, count);
                                temp.str = strdup(s);
                                temp.type = strdup("real");
                                if (is_int($1)) {
                                    if ($1.str[0] = 't') {
                                        printf("%d\t%s := int_to_real %s\n", nextstat++, s, $1.str);
                                    }
                                    else {
                                        printf("%d\t%s := int_to_real %d\n", nextstat++, s, $1.intval);
                                    }
                                }
                                else {
                                    if ($3.str[0] = 't') {
                                        printf("%d\t%s := int_to_real %s\n", nextstat++, s, $3.str);
                                    }
                                    else {
                                        printf("%d\t%s := int_to_real %d\n", nextstat++, s, $3.intval);
                                    }
                                }
                            }
                            newtemp(s, count);
                            $$.str = strdup(s);
                            if (is_real($1) && is_real($3)) {
                                printf("%d\t%s := %s real%c %s\n", nextstat++, $$.str, $1.str, $2, $3.str);
                            }
                            else if (is_real(temp)) {
                                if (is_int($1)) printf("%d\t%s := %s real%c %s\n", nextstat++, $$.str, temp.str, $2, $3.str);
                                else printf("%d\t%s := %s real%c %s\n", nextstat++, $$.str, $1.str, $2, temp.str);
                            }
                            else {
                                printf("%d\t%s := %s %c %s\n", nextstat++, $$.str, $1.str, $2, $3.str);
                            }
                            eval (&$$, $1, $2, $3);
                        };

e : MINUS e %prec NEG   {
                            newtemp(s, count);
                            $$.str = strdup(s);
                            if (is_int($2) || is_real($2) || is_void($2)) {
                                $$.type = strdup($2.type);
                                if (is_int($2)) $$.intval = - $2.intval;
                                if (is_real($2)) $$.realval = - $2.realval;
                            }
                            else {
                                $$.type = strdup("type_error");
                            }
                            printf ("%d\t%s := %c%s\n", nextstat++, $$.str, $1, $2.str);
                        };

e : LEFT e RIGHT        {
                            $$.str = strdup($2.str);
                            $$.type = strdup($2.type);
                            if (is_int($2)) {
                                $$.intval = $2.intval;
                            }
                            else if (is_real($2)) {
                                $$.realval = $2.realval;
                            }
                            else if (is_boolean($2)) {
                                $$.boolval = $2.boolval;
                            }
                        };

e : ID                  {
                            $$.str = strdup($1);
                            $$.type = strdup("void");
                        };

e : VAL                 {
                            char p[256] = "";
                            if (strcmp($1.type, "integer") == 0) {
                                sprintf(p, "%d", $1.intval);
                                $$.intval = $1.intval;
                            }
                            else if (strcmp($1.type, "real") == 0) {
                                sprintf(p, "%f", $1.realval);
                                $$.realval = $1.realval;
                            }
                            $$.str = strdup(p);
                            $$.type = strdup($1.type);
                        };

e : e AND e             {
                            newtemp(s, count);
                            $$.str = strdup(s);
                            bool_eval(&$$, $1, $2, $3);
                            printf ("%d\t%s := %s AND %s\n", nextstat++, $$.str, $1.str, $3.str);
                        };

e : e OR e              {
                            newtemp(s, count);
                            $$.str = strdup(s);
                            bool_eval(&$$, $1, $2, $3);
                            printf ("%d\t%s := %s OR %s\n", nextstat++, $$.str, $1.str, $3.str);
                        };

e : NOT e               {
                            newtemp(s, count);
                            $$.str = strdup(s);
                            if (is_boolean($2)) {
                                $$.type = strdup("boolean");
                                if (!$2.boolval) $$.boolval = 1;
                                else if ($2.boolval) $$.boolval = 0;
                            }
                            else {
                                $$.type = strdup("type_error");
                            }
                            printf ("%d\t%s := NOT %s\n", nextstat++, $$.str, $2.str);
                        };

e : e GREATER e         {
                            newtemp(s, count);
                            $$.str = strdup(s);
                            relop_eval(&$$, $1, $2, $3);
                            printf("%d\tif %s %s %s goto %d\n", nextstat, $1.str, $2, $3.str, nextstat + 3);
                            nextstat++;
                            printf("%d\t%s := 0\n", nextstat++, $$.str);
                            printf("%d\tgoto %d\n", nextstat, nextstat + 2);
                            nextstat++;
                            printf("%d\t%s := 1\n", nextstat++, $$.str);
                        };

e : e LESSER e          {
                            newtemp(s, count);
                            $$.str = strdup(s);
                            relop_eval(&$$, $1, $2, $3);
                            printf("%d\tif %s %s %s goto %d\n", nextstat, $1.str, $2, $3.str, nextstat + 3);
                            nextstat++;
                            printf("%d\t%s := 0\n", nextstat++, $$.str);
                            printf("%d\tgoto %d\n", nextstat, nextstat + 2);
                            nextstat++;
                            printf("%d\t%s := 1\n", nextstat++, $$.str);
                        };

e : e GREATEQ e         {
                            newtemp(s, count);
                            $$.str = strdup(s);
                            relop_eval(&$$, $1, $2, $3);
                            printf("%d\tif %s %s %s goto %d\n", nextstat, $1.str, $2, $3.str, nextstat + 3);
                            nextstat++;
                            printf("%d\t%s := 0\n", nextstat++, $$.str);
                            printf("%d\tgoto %d\n", nextstat, nextstat + 2);
                            nextstat++;
                            printf("%d\t%s := 1\n", nextstat++, $$.str);
                        };

e : e LESSEQ e          {
                            newtemp(s, count);
                            $$.str = strdup(s);
                            relop_eval(&$$, $1, $2, $3);
                            printf("%d\tif %s %s %s goto %d\n", nextstat, $1.str, $2, $3.str, nextstat + 3);
                            nextstat++;
                            printf("%d\t%s := 0\n", nextstat++, $$.str);
                            printf("%d\tgoto %d\n", nextstat, nextstat + 2);
                            nextstat++;
                            printf("%d\t%s := 1\n", nextstat++, $$.str);
                        };

e : e EQUAL e           {
                            newtemp(s, count);
                            $$.str = strdup(s);
                            relop_eval(&$$, $1, $2, $3);
                            printf("%d\tif %s %s %s goto %d\n", nextstat, $1.str, $2, $3.str, nextstat + 3);
                            nextstat++;
                            printf("%d\t%s := 0\n", nextstat++, $$.str);
                            printf("%d\tgoto %d\n", nextstat, nextstat + 2);
                            nextstat++;
                            printf("%d\t%s := 1\n", nextstat++, $$.str);
                        };

e : e NOTEQUAL e        {
                            newtemp(s, count);
                            $$.str = strdup(s);
                            relop_eval(&$$, $1, $2, $3);
                            printf("%d\tif %s %s %s goto %d\n", nextstat, $1.str, $2, $3.str, nextstat + 3);
                            nextstat++;
                            printf("%d\t%s := 0\n", nextstat++, $$.str);
                            printf("%d\tgoto %d\n", nextstat, nextstat + 2);
                            nextstat++;
                            printf("%d\t%s := 1\n", nextstat++, $$.str);
                        };

e : TRUE                {
                            newtemp(s, count);
                            $$.str = strdup(s);
                            $$.type = strdup("boolean");
                            $$.boolval = 1;
                            printf("%d\t%s := 1\n", nextstat++, $$.str);
                        };

e : FALSE               {
                            newtemp(s, count);
                            $$.str = strdup(s);
                            $$.type = strdup("boolean");
                            $$.boolval = 0;
                            printf("%d\t%s := 0\n", nextstat++, $$.str);
                        };

%%

main() {
    yyparse();
}

yyerror (char *s) {
    fprintf(stderr, "%s\n", s);
}

