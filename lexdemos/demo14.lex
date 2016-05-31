%%
ab   { printf("T_A-THEN-B:%s\n", yytext); }
.    { printf("Error: unknown token %s\n", yytext); }
