
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

Changes to hw2 files Decaf spec and Decaf.asdl 
------------------------------------

The following changes were made on Jun 11, 2016 to the testcases,
the Decaf spec and the Decaf AST definition in Decaf.asdl.

To get the updated files for hw2 go to your cloned repo for `compilers-class-hw`

    cd your-path-to/compilers-class-hw
    git pull origin master

## Testcases changed

The testcases were updated. 

* Some files were removed and some were added to make a nice round
score of 200 possible.
* The main change was made to the output of StringConstant which
retains the escape characters and does not interpret them (we will
have to do this for hw3 and hw4, but for hw2 keeping the string
output identical to hw1 enables us to have a single line output for
each input Decaf file).

## Decaf spec changes

Before:

    ExternType = ( string | MethodType ) .

After:

    ExternType = ( string | Type ) .

A void type implies no arguments, e.g. for `read_int(void)` but if
we use MethodType then `read_int(void, void, void)` would be valid
but it should not be.

## Decaf.asdl changes

Added new line to reflect that a Statement can be a Block:

    statement = assign
        ... all the other definitions for statement ...
        | block

The definition of `extern_type` was fixed:

    extern_type  = VarDef(StringType) | VarDef(decaf_type)

Fixed the definition of `ArrayLocExpr` which previously had a third
argument (copy/pasted from `AssignArrayLoc` by mistake).

    ArrayLocExpr(identifier name, expr index)

