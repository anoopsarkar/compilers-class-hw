%{
#include "multexpr.tab.h"
#include <stdlib.h>
extern int yylval;
%}
%%
[0-9]+   { yylval = atoi(yytext); return NUMBER; }
[a-z]    { yylval = yytext[0]; return NAME; }
[ \t]    ;
\n |
.        return yytext[0];
%%
