%%
a+/b  { printf("T_AB:%s\n", yytext); }
a+/c  { printf("T_AC:%s\n", yytext); }
b     { printf("T_B:%s\n", yytext); }
c     { printf("T_C:%s\n", yytext); }
.|\n  ECHO;
