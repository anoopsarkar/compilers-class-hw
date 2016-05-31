%%
a+    { printf("T_A-PLUS:%s\n", yytext); }
.    { printf("Error: unknown token %s\n", yytext); }
