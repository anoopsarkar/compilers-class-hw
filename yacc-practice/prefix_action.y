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

e: { printf("+"); } e '+' t
 | t
 ;

t: { printf("*"); } t '*' f
 | f
 ;

f: T_ID { printf("%s", $1); free($1); }
 | '(' e ')'
 ;

%%

