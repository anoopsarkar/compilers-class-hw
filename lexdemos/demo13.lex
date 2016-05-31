%%
a{2,3}    { printf("T_A-TWO-OR-THREE:%s\n", yytext); }
.    { printf("Error: unknown token %s\n", yytext); }
