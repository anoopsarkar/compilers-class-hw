%{ 
#include "exprdefs.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Verifier.h"
#include "llvm/IR/IRBuilder.h"
#include <cstdio> 
#include <stdexcept>

using namespace llvm;
typedef Value descriptor;

#include "symboltable.cc"

// syms contains all the variable names used 
symboltable syms;

// this global variable contains all the generated code
static Module *TheModule;

// this is the method used to construct the LLVM intermediate code (IR)
static IRBuilder<> Builder(getGlobalContext());
// the calls to getGlobalContext() in the init above and in the
// following code ensures that we are incrementally generating
// instructions in the right order

static Function *TheFunction = 0;

/// ExprAST - Base class for all expression nodes.
class ExprAST {
public:
  virtual ~ExprAST() {}
  virtual Value *Codegen() = 0;
};

/// NumberExprAST - Expression class for integer numeric literals like "12".
class NumberExprAST : public ExprAST {
  int Val;
public:
  NumberExprAST(int val) : Val(val) {}
  virtual Value *Codegen();
};

/// VariableExprAST - Expression class for variables like "a".
class VariableExprAST : public ExprAST {
  string Name;
public:
  VariableExprAST(string name) : Name(name) {}
  const std::string &getName() const { return Name; }
  virtual Value *Codegen();
};

/// BinaryExprAST - Expression class for a binary operator.
class BinaryExprAST : public ExprAST {
  char Op;
  ExprAST *LHS, *RHS;
public:
  BinaryExprAST(char op, ExprAST *lhs, ExprAST *rhs) 
    : Op(op), LHS(lhs), RHS(rhs) {}
  virtual Value *Codegen();
  ~BinaryExprAST() {
    delete LHS;
    delete RHS;
  }
};

// we also have to create a main function that contains
// all the code generated for the expression and the print_int call
Function *gen_main_def() {
  // create the top-level definition for main
  FunctionType *FT = FunctionType::get(IntegerType::get(getGlobalContext(), 32), false);
  Function *TheFunction = Function::Create(FT, Function::ExternalLinkage, "main", TheModule);
  if (TheFunction == 0) {
    throw runtime_error("empty function block"); 
  }
  // Create a new basic block which contains a sequence of LLVM instructions
  BasicBlock *BB = BasicBlock::Create(getGlobalContext(), "entry", TheFunction);
  // All subsequent calls to IRBuilder will place instructions in this location
  Builder.SetInsertPoint(BB);
  return TheFunction;
}

/// CreateEntryBlockAlloca - Create an alloca instruction in the entry block of
/// the function.  This is used for mutable variables etc.
static AllocaInst *CreateEntryBlockAlloca(Function *TheFunction, const std::string &VarName) {
  IRBuilder<> TmpB(&TheFunction->getEntryBlock(), TheFunction->getEntryBlock().begin());
  return TmpB.CreateAlloca(IntegerType::get(getGlobalContext(), 32), 0, VarName.c_str());
}

%}

%union{
  class ExprAST *ast;
  string *sval;
  int number;
}

%token <number> NUMBER
%token <sval> NAME
%type <ast> expression
%%
statement_list: statement ';' statement_list
              | /* empty */
              ;
statement: NAME '=' expression
	   { 
	     Value *RetVal = $3->Codegen();
	     AllocaInst *Alloca;
	     if (NULL == (Alloca = (AllocaInst *)syms.access_symtbl(*$1))) {
	       // unlike CreateEntryBlockAlloca the following will
	       // create the alloca instr at the current insertion point in the 
	       // basic block
	       Alloca = Builder.CreateAlloca(IntegerType::get(getGlobalContext(), 32), 0, $1->c_str());
	       syms.enter_symtbl(*$1, Alloca);
	     }
	     Value *LHS = Builder.CreateStore(RetVal, Alloca);
	     delete($1); // remove allocated string for NAME
	     delete($3); // get rid of abstract syntax tree	     
  	   }
         | NAME '(' expression ')'
	   {
	     Value *RetVal = $3->Codegen();
	     Function *CalleeF;
	     if (NULL == (CalleeF = (Function *)syms.access_symtbl(*$1))) {
	       // create a extern definition for function call
	       std::vector<Type*> args;
	       args.push_back(IntegerType::get(getGlobalContext(), 32)); // takes one integer argument
	       FunctionType *Ty = FunctionType::get(IntegerType::get(getGlobalContext(), 32), args, false);
	       Function *F = Function::Create(Ty, Function::ExternalLinkage, *$1, TheModule);
	       CalleeF = TheModule->getFunction(F->getName());
	       syms.enter_symtbl(*$1, CalleeF);
	     }
	     if (CalleeF == 0) {
	       throw runtime_error("could not find the function print_int\n");
	     }
	     // print the value of the expression and we are done
	     Value *CallF = Builder.CreateCall(CalleeF, RetVal, "calltmp");
	     delete($1); // remove allocated string for NAME
	     delete($3); // get rid of abstract syntax tree	     
	   }
         ;

expression: expression '+' NUMBER 
            { 
	      $$ = new BinaryExprAST('+', $1, new NumberExprAST($3));
	    }
          | expression '-' NUMBER 
            { 
	      $$ = new BinaryExprAST('-', $1, new NumberExprAST($3)); 
	    }
          | expression '+' NAME 
            { 
	      $$ = new BinaryExprAST('+', $1, new VariableExprAST(*$3));
	      delete($3);
	    }
          | expression '-' NAME 
            { 
	      $$ = new BinaryExprAST('-', $1, new VariableExprAST(*$3)); 
	      delete($3);
	    }
          | NUMBER 
	    { 
	      $$ = new NumberExprAST($1); 
	    }
          | NAME 
	    { 
	      $$ = new VariableExprAST(*$1); 
	      delete($1);
	    }
          ;
%%

Value *VariableExprAST::Codegen() {
  Value *V = syms.access_symtbl(Name);
  if (V == 0) {
    throw runtime_error("could not find variable: " + Name);
  }
  return Builder.CreateLoad(V, Name.c_str());
}

Value *NumberExprAST::Codegen() {
  return ConstantInt::get(getGlobalContext(), APInt(32, Val));
}

Value *BinaryExprAST::Codegen() {
  Value *L = LHS->Codegen();
  Value *R = RHS->Codegen();
  if (L == 0 || R == 0) return 0;
  
  switch (Op) {
  case '+': return Builder.CreateAdd(L, R, "addtmp");
  case '-': return Builder.CreateSub(L, R, "subtmp");
  default: throw runtime_error("what operator is this? never heard of it.");
  }
}

int main() {
  // initialize LLVM
  LLVMContext &Context = getGlobalContext();
  // Make the module, which holds all the code.
  TheModule = new Module("module for simple expressions", Context);
  // set up the declaration of the print_int function
  TheFunction = gen_main_def();
  // set up symbol table
  syms.new_symtbl();
  // parse the input and create the abstract syntax tree
  int retval = yyparse();
  // remove symbol table
  syms.remove_symtbl();
  // Finish off the main function.
  // return 0 from main, which is EXIT_SUCCESS
  Builder.CreateRet(ConstantInt::get(getGlobalContext(), APInt(32, 0)));
  // Validate the generated code, checking for consistency.
  verifyFunction(*TheFunction);
  // Print out all of the generated code to stderr
  TheModule->dump();
  return(retval >= 1 ? 1 : 0);
}
