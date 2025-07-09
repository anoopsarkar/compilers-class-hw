
%{

#include <iostream>
#include <cstdlib>

using namespace std;

/* token definitions */
#define T_FUNC 16
#define T_INT 21
#define T_PACKAGE 35
#define T_LCB 22
#define T_RCB 37
#define T_LPAREN 25
#define T_RPAREN 40
#define T_ID 49
#define T_WHITESPACE 50
#define NUMTOKENS 10

%}

%%
  /*
    Pattern definitions for all tokens
  */
func                       { return T_FUNC; }
int                        { return T_INT; }
package                    { return T_PACKAGE; }
\{                         { return T_LCB; }
\}                         { return T_RCB; }
\(                         { return T_LPAREN; }
\)                         { return T_RPAREN; }
[a-zA-Z\_][a-zA-Z\_0-9]*   { return T_ID; }
[\t\r\a\v\b ]+             { return T_WHITESPACE; }
\n                         { return 10; }
.                          { cerr << "Error: unexpected character in input" << endl; return -1; }

%%

int main () {
  int token;
  string lexeme;
  while ((token = yylex())) {
    if (token > 0) {
      lexeme.assign(yytext);
      switch(token) {
        case 1: cout << "T_FUNC " << lexeme << endl; break;
        case 2: cout << "T_INT " << lexeme << endl; break;
        case 3: cout << "T_PACKAGE " << lexeme << endl; break;
        case 4: cout << "T_LCB " << lexeme << endl; break;
        case 5: cout << "T_RCB " << lexeme << endl; break;
        case 6: cout << "T_LPAREN " << lexeme << endl; break;
        case 7: cout << "T_RPAREN " << lexeme << endl; break;
        case 8: cout << "T_ID " << lexeme << endl; break;
        case 9: cout << "T_WHITESPACE " << lexeme << endl; break;
        case 10: cout << "T_WHITESPACE \\n" << endl; break;
        default: exit(EXIT_FAILURE);
      }
    } else {
      if (token < 0) {
        exit(EXIT_FAILURE);
      }
    }
  }
  exit(EXIT_SUCCESS);
}
