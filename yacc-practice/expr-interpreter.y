%{
#include "exprdefs.h"
#include <cstdlib>
#include <cstdio>
#include <cmath>

int yylex(void);
int yyerror(char *); 

 using namespace std;

 double symtbl[26];
 bool issym[26];

%}

%union {
  int rvalue; /* int value of evaluated expression */
  double dbl_rvalue; /* value of type double for evaluated expression */
  int lvalue; /* index into symtbl for variable name */
}

%token <dbl_rvalue> T_DOUBLE
%token <rvalue> T_NUMBER
%token <lvalue> T_NAME
%token T_EXP T_SQRT T_LOG

%type <dbl_rvalue> expression

%%
statement_list : statement '\n' statement_list
   |
   ;

statement: T_NAME '=' expression { symtbl[$1] = $3; issym[$1] = true; }
   | expression  { printf("%lf\n", $1); }
   ;

expression: expression '+' T_NUMBER { $$ = $1 + $3; }
   | expression '-' T_NUMBER { $$ = $1 - $3; }
   | expression '+' T_DOUBLE { $$ = $1 + $3; }
   | expression '-' T_DOUBLE { $$ = $1 - $3; }
   | expression '+' T_NAME 
	 { 
	    if (issym[$3]) { $$ = $1 + symtbl[$3]; } 
	    else { fprintf(stderr, "Error: variable %c not previously defined\n", $3+'a'); exit(1); }
	 }
   | expression '-' T_NAME 
	 { 
	    if (issym[$3]) { $$ = $1 - symtbl[$3]; } 
	    else { fprintf(stderr, "Error: variable %c not previously defined\n", $3+'a'); exit(1); }
	 }
   | T_NUMBER { $$ = $1; }
   | T_DOUBLE { $$ = $1; }
   | T_NAME 
	 { 
	    if (issym[$1]) { $$ = symtbl[$1]; } 
	    else { fprintf(stderr, "Error: variable %c not previously defined\n", $1+'a'); exit(1); }
	 }
   | T_EXP '(' expression ')' { $$ = exp($3); }
   | T_SQRT '(' expression ')' { $$ = sqrt($3); }
   | T_LOG '(' expression ')' { $$ = log($3); }
   ;

%%

