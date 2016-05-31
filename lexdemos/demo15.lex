%%
a|b  { printf("T_A-OR-B:%s\n", yytext); }
.    { printf("Error: unknown token %s\n", yytext); }
