%{
#include "exprdefs.h"
#include "sexpr2-codegen.tab.h"
#include <cstdlib>
%}
%%
[0-9]+                     { yylval.number = atoi(yytext); return NUMBER; }
[a-zA-Z\_][a-zA-Z\_0-9]*   { yylval.sval = new string(yytext); return NAME; }
[ \t\n]                    ;
.                          return yytext[0];
%%
