%%
"**"    { printf("T_ASTERISKS:%s\n", yytext); }
.    { printf("Error: unknown token %s\n", yytext); }
