num [0-9]+ 
op  (\+|\*)
ws  [ \t]*
%%

{ws}            { }
{num}({ws}{op}{ws}{num})*   { printf("yes\n"); }
.               { printf("no\n"); }


