%%
a    { printf("T_A:%s\n", yytext); }
b    { printf("T_B:%s\n", yytext); }
.    { printf("Error: unknown token %s\n", yytext); }
