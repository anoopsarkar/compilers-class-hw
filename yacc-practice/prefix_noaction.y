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

e: e '+' t
 | t
 ;

t: t '*' f
 | f
 ;

f: T_ID { free($1); }
 | '(' e ')'
 ;

%%

