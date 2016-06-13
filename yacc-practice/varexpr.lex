%{
#include "varexpr.tab.h"
#include <math.h>
%}

%%
[0-9]+    { yylval.rvalue = atoi(yytext); return NUMBER; } /* convert NUMBER token value to integer */
[ \t]     ;  /* ignore whitespace */
[a-z]     { yylval.lvalue = yytext[0] - 'a'; return NAME; } /* convert NAME token into index */
[a-z]+    { fprintf(stderr, "Error: multi-character variables not allowed\n"); exit(1); }
\n |
.         return yytext[0];
%%
