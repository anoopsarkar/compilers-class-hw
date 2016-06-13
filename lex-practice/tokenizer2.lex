%{
#include <stdio.h>
#include <stdlib.h>
#define T_A 256
#define T_B 257
#define T_C 258
#define ERROR 666
%}

%%

cda*      { return T_A; }
c*a*c     { return T_B; }
c*b       { return T_C; }
\n
.         { return ERROR; }

%%

int main () {
  int token;
  while ((token = yylex())) {
    switch (token) {
      case T_A: printf("T_A %s\n", yytext); break;
      case T_B: printf("T_B %s\n", yytext); break;
      case T_C: printf("T_C %s\n", yytext); break;
      default: fprintf(stderr, "illegal token\n"); printf("ERROR %s\n", yytext);
    }
  }
  exit(0);
}
