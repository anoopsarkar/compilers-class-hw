%%
a    { printf("T_A:%s\n", yytext); }
.    { printf("Error: unknown token %s\n", yytext); }
