%%
a*b+/c+  { printf("T_AB:%s\n", yytext); }
a*b*c/a  { printf("T_ABC:%s\n", yytext); }
a        { printf("T_A:%s\n", yytext); }
c        { printf("T_C:%s\n", yytext); }
.|\n  ECHO;
