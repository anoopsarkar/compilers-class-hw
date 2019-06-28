
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

Getting Started
----------------

The next 3 sections can be completed non-sequentially, but at least some work must be completed in every section to create a visible difference in output.

### Input

You need to use the lexer which you built in HW1. The parser will handle the tokens so there is no need to `#define` these tokens in `decafast.lex`.

Copy only your token pattern definitions from `decaflex.lex` in HW1 to `decafast.lex`. Do not copy anything from `int main()` as there is a new `int main()` function in `decafast.y`.

As in the default action for `T_ID` from `default.lex`, make sure to assign values directly to `yyval` whenever appropriate.

While whitespace was an explicit token in HW1, it is no longer necessary in HW2. Make sure that no token is returned upon recognizing whitespace, or a syntax error may occur.

The lexer will be run first, after which the parser will receive the tokens.

### Grammar and Program Structure

The parser will receive the tokens and match the sequence of tokens to a valid set of rules governing the Decaf language.

In `decafast.y`, write Yacc grammar rules as per the Decaf Specification (see [Decaf Grammar](decafspec.html#decaf-grammar)) to parse the tokens created by the lexer in the structure required by the language.

Add `%token` and `%type<>` definitions to `decafast.y` as necessary. This is how the parser will receive and understand tokens processed by the lexer.

### Output

An abstract syntax tree (AST) is a high-level representation of the program structure without the necessity of containing all the details in the source code; it can be thought of as an abstract representation of the source code.

The specification for the abstract syntax tree to be produced by your program is given below using the Zehpyr Abstract Syntax Definition Language.

For each grammar rule in decafast.y, write an action to create the structure of the program as you parse it component by component.

The actions will use classes from decafast.cc. Write more classes as necessary in this file, inheriting from the abstract decafAST template which will allow objects to be constructed and passed back through the rules. See class ProgramAST and class PackageAST for examples.

The specification for the abstract syntax tree to be produced by your program is given in the file `Decaf.asdl` in this directory. It uses the Zehpyr Abstract Syntax Definition Language. Write the string str() {} function in the classes in `decafast.cc` to output the syntax tree as a stream of text which is formed with the following specification.

