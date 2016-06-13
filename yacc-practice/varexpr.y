%{
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

int yylex(void);
int yyerror(char *); 

int symtbl[26];
bool issym[26];
%}

%union {
  int rvalue; /* value of evaluated expression */
  int lvalue; /* index into symtbl for variable name */
}

%token <rvalue> NUMBER
%token <lvalue> NAME 

%type <rvalue> expression
%type <rvalue> const

%%
statement_list : statement '\n'
      | statement_list statement '\n'
      ;

statement: NAME '=' expression { symtbl[$1] = $3; issym[$1] = true; }
      | expression  { printf("%d\n", $1); }
      ;

expression: expression '+' const { $$ = $1 + $3; }
      | expression '-' const { $$ = $1 - $3; }
      | const { $$ = $1; }
      ;

const: NUMBER { $$ = $1; }
     | NAME 
	   { 
		  if (issym[$1]) { $$ = symtbl[$1]; } 
		  else { fprintf(stderr, "Error: variable %c not previously defined\n", $1+'a'); exit(1); }
	   }
     ;
%%

