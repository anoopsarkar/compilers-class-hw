
Naming your files
-----------------

The file `decafexpr.asdl` contains the part of the abstract syntax
tree for which you should implement code generation using LLVM.

To create the default program, go to the answer directory and type
in `make default`. To run the default program against the testcases,
run the following commands:

    python zipout.py -r default
    python check.py

In the answer directory use the following filenames for
your homework solution:

* Lex program: decafexpr.lex
* Yacc program: decafexpr.y

We are going to use GNU `bison` as the implementation of `yacc`.

If you have these filenames then you can use `make` to build your
binary `decafexpr` from your Lex and Yacc programs.

There are also helper make commands to check LLVM assembly programs.

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

## Testcases changed

The testcases and references were updated on Jun 23, 2016. Now
`zipout.py` calls `answer/llvm-run` to check if the LLVM assembly
can be converted to a successfully running binary. Due to this
change, a lot of `print_int` and `print_string` statements were
added to the Decaf programs.

Also, if the Decaf program has a call to `read_int` from the Decaf
standard library then there must be a file with an `.in` suffix in
the testcases directory which contains the input for `read_int`.

