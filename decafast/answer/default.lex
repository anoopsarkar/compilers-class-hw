%{
#include "default-defs.h"
#include "default.tab.h"
#include <cstring>
#include <string>
#include <sstream>
#include <iostream>

using namespace std;

int lineno = 1;
int tokenpos = 1;

%}

%%
  /*
    Pattern definitions for all tokens 
  */
package                    { return T_PACKAGE; }
\{                         { return T_LCB; }
\}                         { return T_RCB; }
[a-zA-Z\_][a-zA-Z\_0-9]*   { yylval.sval = new string(yytext); return T_ID; } /* note that identifier pattern must be after all keywords */
[\t\r\n\a\v\b ]+           { } /* ignore whitespace */
.                          { cerr << "Error: unexpected character in input" << endl; return -1; }

%%

int yyerror(const char *s) {
  cerr << lineno << ": " << s << " at char " << tokenpos << endl;
  return 1;
}

