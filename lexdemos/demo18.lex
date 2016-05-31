%%
a*b*c   { printf("T_A-STAR-B-STAR-THEN-C:%s\n", yytext); }
.       { printf("Error: unknown token %s\n", yytext); }
