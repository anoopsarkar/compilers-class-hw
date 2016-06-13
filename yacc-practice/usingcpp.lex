%{
/* example that illustrates using C++ code and flex/bison */
#include "usingcpp-defs.h"
#include "usingcpp.tab.h"
#include <cstring>
using namespace std;
%}

%%
[a-z]                  { yylval.sval = strdup(yytext); return NAME; }
[ \t\n]                ;
.                      return yytext[0];
%%

