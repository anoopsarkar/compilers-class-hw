
Naming your files
-----------------

To create the default program, go to the answer directory and type
in `make default`. To run the default program against the testcases,
run the following commands:

    python zipout.py -r default
    python check.py

The output files are all saved to the `output` directory which has
a sub-directory called `llvm` which contains all the intermediate
LLVM files created for each input Decaf program.

In the answer directory use the following filenames for your homework
solution:

* Lex program: decafcomp.lex
* Yacc program: decafcomp.y

We are going to use GNU `bison` as the implementation of `yacc`.

If you have these filenames then you can use `make` to build your
binary `decafcomp` from your Lex and Yacc programs.

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

Getting Started
---------------

As usual start by copying and modifying your solution for HW3 (the `decafexpr` source code).

* `makefile`: contains the necessary recipes for building LLVM assembly code, C++ code using LLVM API calls and Lex/Yacc programs that use the LLVM API.
* `decaf-stdlib.c`: the Decaf standard library. Contains the extern functions used commonly in Decaf programs.
* Default solution files:
    * `default-defs.h`: the common header file among all the default files
    * `default.cc`: the default classes for LLVM code generation
    * `default.lex`: the lexer for Decaf
    * `default.y`: the yacc program for a small fragment of Decaf which uses `default.cc` for LLVM code generation.
* `llvm-run`: the Python program used by `check.py` in order to run a Decaf program using the following steps. Each step assumes some file names but can be changed using command line options so run `llvm-run -h` to see the options and also read the source code of `llvm-run` to understand what it is doing.  Stages are:
    1. llvm:  source code to LLVM code generation using your `decafexpr` program
    2. bc:    assembly to LLVM bitcode
    3. s:     bitcode to native code
    4. exec:  linking to make native executable
    5. run:   running the final executable

There is also a directory called `dev_llvm` which contains sample
output LLVM assembly for each Decaf program in `testcases/dev`. You
can check that your output LLVM assembly is roughly doing the right
thing by comparing your output to this sample output. Note that
your output LLVM assembly does not have to be identical to the
sample output for the correct output to be produced.

