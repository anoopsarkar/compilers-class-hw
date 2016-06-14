%{
#include <stdio.h>
#include <stdlib.h>
%}

%union {
  char *sval;
}

%token <sval> T_ID

%%

start: e

e: m1 e '+' t
 | t
 ;

t: m2 t '*' f
 | f
 ;

f: T_ID { printf("%s", $1); free($1); }
 | '(' e ')'
 ;

m1: { printf("+"); }

m2: { printf("*"); }

%%

