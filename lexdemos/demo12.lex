%%
a?    { printf("T_A-OPTIONAL:%s\n", yytext); }
.    { printf("Error: unknown token %s\n", yytext); }
