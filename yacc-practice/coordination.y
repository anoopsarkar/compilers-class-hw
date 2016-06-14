%token JOHN BILL AND LAUGHED CRIED
%%
s: np vp
 | s AND s
 ;
vp: v
  | vp AND vp
  ;
v: LAUGHED
 | CRIED
 ;
np: JOHN
  | BILL
  ;
%%
