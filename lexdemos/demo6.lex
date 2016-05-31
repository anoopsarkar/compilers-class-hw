%%
^abc    { printf("T_STARTWITH-ABC:%s\n", yytext); }
.    { printf("Error: unknown token %s\n", yytext); }
