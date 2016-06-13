%%
int                     ECHO;
main                    ECHO;
printf					ECHO;
\#include               ECHO;
\<[^\>]*\>				ECHO;
\"[^\"]*\"				ECHO;
[a-zA-Z][a-zA-Z0-9]*    printf("%c", yytext[0]);
[ \t\n]*                ECHO;
.                       ECHO; /* print everything else */
