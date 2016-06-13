%{
#include <stdio.h>

int yylex(void);
int yyerror(char *); 

%}
%token NAME NUMBER
%%
 /* statement_list: statement_list statement '\n' */
statement_list: statement '\n' statement_list
     |
     ;

statement: NAME '=' expression { printf("%c = %d\n", $1, $3); }
     | expression  { printf("%d\n", $1); }
     ;

expression: expression '+' NUMBER { $$ = $1 + $3; }
     | expression '-' NUMBER { $$ = $1 - $3; }
     | NUMBER { $$ = $1; }
     ;
%%

