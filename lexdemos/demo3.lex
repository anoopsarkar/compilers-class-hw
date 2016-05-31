%%
\*    { printf("T_ASTERISK:%s\n", yytext); }
.    { printf("Error: unknown token %s\n", yytext); }
