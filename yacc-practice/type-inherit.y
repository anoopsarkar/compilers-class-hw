%{
#include "type-inherit-defs.h"
#include <iostream>

  extern int lineno;
  symboltable syms;

  using namespace std;

  void enter_symtbl(string ident, string type, int lineno) {
    syms.enter_symtbl(ident, new descriptor(lineno));
    cerr << "defined variable: " << ident << ", with type: " << type << ", on line number: " << lineno << endl;
  }

%}

%union {
  string *typeval;
  string *sval;
}

%token T_INT T_BOOL 
%token <sval> T_ID
%type <typeval> id_comma_list type

%%
block: begin_block var_decl_list end_block

begin_block: '{'
  {
    syms.new_symtbl();
  }

end_block: '}'
  {
    syms.remove_symtbl();
  }

var_decl_list: var_decl var_decl_list
     | 
     ;

var_decl: type { $<typeval>$ = $1; } id_comma_list ';' { delete $1; }

id_comma_list: T_ID ',' { $<typeval>$ = $<typeval>0; } id_comma_list 
  { 
    enter_symtbl(*$1, *($<typeval>0), lineno); 
    delete $1; 
  }
     | T_ID 
  { 
    enter_symtbl(*$1, *($<typeval>0), lineno); 
    delete $1; 
  }
     ;

type: T_INT { string *s = new string("int"); $$ = s; } 
     | T_BOOL { string *s = new string("bool"); $$ = s; } ;

%%

