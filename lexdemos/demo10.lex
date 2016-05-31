%%
a*    { printf("T_A-STAR:%s\n", yytext); }
.    { printf("Error: unknown token %s\n", yytext); }
