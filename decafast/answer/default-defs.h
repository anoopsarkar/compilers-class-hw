
#ifndef _DECAF_DEFS
#define _DECAF_DEFS

#include <cstdio> 
#include <cstdlib>
#include <cstring> 
#include <string>
#include <stdexcept>
#include <vector>


extern int lineno;
extern int tokenpos;

using namespace std;

extern "C"
{
	extern int yyerror(const char *);
	int yyparse(void);
	int yylex(void);  
	int yywrap(void);
}

#endif

