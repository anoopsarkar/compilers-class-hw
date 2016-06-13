%{
#include "exprdefs.h"
#include "expr-interpreter.tab.h"
#include <cmath>
#include <cstdlib>

  using namespace std;

  extern double symtbl[26];

%}

%%
exp       { return T_EXP; }
sqrt      { return T_SQRT; }
log       { return T_LOG; }
[0-9]*\.[0-9]+  { yylval.dbl_rvalue = atof(yytext); return T_DOUBLE; } /* convert token value to double */
[0-9]+    { yylval.rvalue = atoi(yytext); return T_NUMBER; } /* convert token value to integer */
[ \t]     ;  /* ignore whitespace */
[a-z]     { yylval.lvalue = yytext[0] - 'a'; return T_NAME; } /* convert token into index */
\n |
.         return yytext[0];
%%
