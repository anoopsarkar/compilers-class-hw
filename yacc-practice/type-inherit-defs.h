
#ifndef _TYPE_INHERIT_DEFS
#define _TYPE_INHERIT_DEFS

#include <string>
#include <iostream>

using namespace std;

class descriptor {
public:
  int lineno; // line number where identifier was declared

  descriptor(int num) { lineno = num; }

  void print() { cerr << "line: " << lineno << endl; }
};

#include "symboltable.cc"

extern "C"
{
  int yyerror(const char *);
  int yyparse(void);
  int yylex(void);  
  int yywrap(void);
}

#endif

