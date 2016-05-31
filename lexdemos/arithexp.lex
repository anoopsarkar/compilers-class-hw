%{

int n = -1;

char *remove_spaces(char *str)
{
  char *ns = malloc(sizeof(char *) * (strlen(str)+1));
  char *i, *j;
  j = ns;
  for (i = str; *i; i++) {
     if (*i != ' ') { *j = *i; j++; *j = 0; }
  }
  return ns;
}

int getint(char *str, char *fmt)
{
  int m;
  char *ns = remove_spaces(str);
  sscanf(ns, fmt, &m);
  free(ns);
  return m;
}

/* {num}({ws}{op}{ws}{num})*   { printf("yes\n"); } */

%}

num [0-9]+ 
op  (\+|\*)
ws  [ \t]*
%%

{ws}            { }
{num}           { n = atoi(yytext); printf("%d\n", n); }
{ws}\+{ws}{num} { 
                        int m = getint(yytext, "+%d");
                        if (n < 0) { printf("Error!\n"); exit(-1); } 
                        else { n = n+m; printf("%d\n", n); } 
                }
{ws}\*{ws}{num} { 
                        int m = getint(yytext, "*%d");
                        if (n < 0) { printf("Error!\n"); exit(-1); } 
                        else { n = n*m; printf("%d\n", n); } 
                }
\n              { n = -1; }
.               { printf("no\n"); }


