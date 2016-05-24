
%{

#include <iostream>
#include <cstdlib>

using namespace std;

%}

%%
  /*
    Pattern definitions for all tokens 
  */
func                       { return 1; }
int                        { return 2; }
package					   { return 3; }
\{                         { return 4; }
\}                         { return 5; }
\(                         { return 6; }
\)                         { return 7; }
[a-zA-Z\_][a-zA-Z\_0-9]*   { return 8; }
[\t\r\a\v\b ]+             { return 9; }
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

