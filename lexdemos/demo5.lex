%%
a.*b    { printf("T_B-FOLLOW-A:%s\n", yytext); }
.    { printf("Error: unknown token %s\n", yytext); }
