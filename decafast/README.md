
Naming your files
-----------------

The file `Decaf.asdl` contains the specification of
the output. The input is specified in the Decaf
specification on the class web page.

To create the default program, go to the answer directory
and type in `make default`. To run the default program
against the testcases, run the following commands:

    python zipout.py -r default
    python check.py

In the answer directory use the following filenames for
your homework solution:

* Lex program: decafast.lex
* Yacc program: decafast.y

We are going to use GNU `bison` as the implementation of `yacc`.

If you have these filenames then you can use `make` to build your
binary `decafast` from your Lex and Yacc programs.

Make sure you have a common header file that looks something like
the following that is included in both your Lex and Yacc program.

    #ifndef _DECAF_DEFS
    #define _DECAF_DEFS

    /* include any common header files here, e.g. string, vector, etc. */

    using namespace std;

    /* include any common variables to both lexer and parser, 
       e.g. variables for line number and character position 
    */

    /* you need the following lines to explain to C++ 
       that you are using the C functions created by flex and bison 
    */

    extern "C"
    {
        extern int yyerror(const char *);
        int yyparse(void);
        int yylex(void);  
        int yywrap(void);
    }

    #endif


