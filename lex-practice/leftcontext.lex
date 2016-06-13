%{
/* example illustrating the use of states in lex 

   declare a state called INPUT using: %s INPUT

   enter a state using: BEGIN INPUT

   match a token only if in a certain state: <INPUT>\".*\"
*/
%}

%s INPUT
%s OUTPUT

%%

[ \t\n]+                ;
inputfile       BEGIN INPUT;
outputfile      BEGIN OUTPUT;
<INPUT>\".*\"   { BEGIN 0; ECHO; printf(" is the input file.\n"); }
<OUTPUT>\".*\"  { BEGIN 0; ECHO; printf(" is the output file.\n"); }

%%
