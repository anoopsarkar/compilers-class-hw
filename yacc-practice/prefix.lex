%{
#include "prefix.tab.h"
#include <string.h>
%}

%%
[a-zA-Z\_][a-zA-Z\_0-9]*  { yylval.sval = strdup(yytext); return T_ID; }
[ \t]*                    ;
.                         return yytext[0];
%%
