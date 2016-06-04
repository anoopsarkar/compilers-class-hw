
%{
#include <stdio.h>
%}

%%

..		{ printf("[%c %c]\n", yytext[0], yytext[1]); REJECT; }
\n		;
.		;
%%

int main () {
  yylex();
}

