%%
[^a-z]    { printf("T_NOT-A-TO-Z:%s\n", yytext); }
.    { printf("Error: unknown token %s\n", yytext); }
