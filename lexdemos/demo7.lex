%%
abc$    { printf("T_ENDWITH-ABC:%s\n", yytext); }
.    { printf("Error: unknown token %s\n", yytext); }
