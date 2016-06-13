%{
#include "type-inherit-defs.h"
#include "type-inherit.tab.h"

int lineno = 0;
%}

%%
int                       { return T_INT; }
bool                      { return T_BOOL; }
[a-zA-Z\_][a-zA-Z\_0-9]*  { yylval.sval = new string(yytext); return T_ID; }
[ \t]                     ;
\n                        { lineno++; }
.                         { return yytext[0]; }
%%
