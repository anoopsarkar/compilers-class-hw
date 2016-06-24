%{
#include <iostream>
#include <ostream>
#include <string>
#include <cstdlib>
#include "default-defs.h"

int yylex(void);
int yyerror(char *); 

// print AST?
bool printAST = false;

using namespace std;

// this global variable contains all the generated code
static llvm::Module *TheModule;

// this is the method used to construct the LLVM intermediate code (IR)
static llvm::IRBuilder<> Builder(llvm::getGlobalContext());
// the calls to getGlobalContext() in the init above and in the
// following code ensures that we are incrementally generating
// instructions in the right order

// dummy main function
// should be replaced with actual codegen for the main method 
// using the full Decaf grammar
static llvm::Function *TheFunction = 0;

// we have to create a main function 
llvm::Function *gen_main_def() {
  // create the top-level definition for main
  llvm::FunctionType *FT = llvm::FunctionType::get(llvm::IntegerType::get(llvm::getGlobalContext(), 32), false);
  llvm::Function *TheFunction = llvm::Function::Create(FT, llvm::Function::ExternalLinkage, "main", TheModule);
  if (TheFunction == 0) {
    throw runtime_error("empty function block"); 
  }
  // Create a new basic block which contains a sequence of LLVM instructions
  llvm::BasicBlock *BB = llvm::BasicBlock::Create(llvm::getGlobalContext(), "entry", TheFunction);
  // All subsequent calls to IRBuilder will place instructions in this location
  Builder.SetInsertPoint(BB);
  return TheFunction;
}

#include "default.cc"

%}

%union{
    class decafAST *ast;
    std::string *sval;
 }

%token T_PACKAGE
%token T_LCB
%token T_RCB
%token <sval> T_ID

%type <ast> extern_list decafpackage

%%

start: program

program: extern_list decafpackage
    { 
        ProgramAST *prog = new ProgramAST((decafStmtList *)$1, (PackageAST *)$2); 
		if (printAST) {
			cout << getString(prog) << endl;
		}
        try {
            prog->Codegen();
        } 
        catch (std::runtime_error &e) {
            cout << "semantic error: " << e.what() << endl;
            //cout << prog->str() << endl; 
            exit(EXIT_FAILURE);
        }
        delete prog;
    }

extern_list: /* extern_list can be empty */
    { decafStmtList *slist = new decafStmtList(); $$ = slist; }
	| T_ID extern_list
    { decafStmtList *slist = new decafStmtList(); $$ = slist; }
    ;

decafpackage: T_PACKAGE T_ID T_LCB T_RCB
    { $$ = new PackageAST(*$2, new decafStmtList(), new decafStmtList()); delete $2; }
    | T_PACKAGE T_ID T_LCB ignore T_RCB
    { $$ = new PackageAST(*$2, new decafStmtList(), new decafStmtList()); delete $2; }
    ;

ignore: ignore T_ID
    | ignore T_LCB
    | ignore T_RCB
	| T_ID
	| T_LCB
	| T_RCB
	;

%%

int main() {
  // initialize LLVM
  llvm::LLVMContext &Context = llvm::getGlobalContext();
  // Make the module, which holds all the code.
  TheModule = new llvm::Module("Test", Context);
  // set up symbol table
  // set up dummy main function
  TheFunction = gen_main_def();
  // parse the input and create the abstract syntax tree
  int retval = yyparse();
  // remove symbol table
  // Finish off the main function.
  // return 0 from main, which is EXIT_SUCCESS
  Builder.CreateRet(llvm::ConstantInt::get(llvm::getGlobalContext(), llvm::APInt(32, 0)));
  // Validate the generated code, checking for consistency.
  verifyFunction(*TheFunction);
  // Print out all of the generated code to stderr
  TheModule->dump();
  return(retval >= 1 ? EXIT_FAILURE : EXIT_SUCCESS);
}

