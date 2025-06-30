#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Type.h"
#include "llvm/IR/Verifier.h"
#include "llvm/IR/IRBuilder.h"
#include <stdexcept>

using namespace std;

static llvm::Module *TheModule;
static llvm::LLVMContext TheContext;
static llvm::IRBuilder<> Builder(TheContext);

llvm::Function *genMainDef() {
  // create the top-level definition for main
  llvm::FunctionType *FT = llvm::FunctionType::get(Builder.getInt32Ty(), std::vector<llvm::Type*>(), false);
  llvm::Function *TheFunction = llvm::Function::Create(FT, llvm::Function::ExternalLinkage, "main", TheModule);
  if (TheFunction == 0) {
    throw runtime_error("empty function block"); 
  }
  // Create a new basic block which contains a sequence of LLVM instructions
  llvm::BasicBlock *BB = llvm::BasicBlock::Create(TheContext, "entry", TheFunction);
  // All subsequent calls to IRBuilder will place instructions in this location
  Builder.SetInsertPoint(BB);
  return TheFunction;
}

llvm::Function *genPrintIntDef() {
  // create a extern definition for print_int
  std::vector<llvm::Type*> args;
  args.push_back(Builder.getInt32Ty()); // print_int takes one i32 argument
  return llvm::Function::Create(llvm::FunctionType::get(Builder.getVoidTy(), args, false), llvm::Function::ExternalLinkage, "print_int", TheModule);
}

int main() {
  // initialize LLVM
  // Make the module, which holds all the code.
  TheModule = new llvm::Module("array global variable example", TheContext);

  // array size = 10
  llvm::ArrayType *arrayi32 = llvm::ArrayType::get(Builder.getInt32Ty(), 10);
  // zeroinitalizer: initialize array to all zeroes
  llvm::Constant *zeroInit = llvm::Constant::getNullValue(arrayi32);
  // declare a global variable
  llvm::GlobalVariable *Foo = new llvm::GlobalVariable(*TheModule, arrayi32, false, llvm::GlobalValue::ExternalLinkage, zeroInit, "Foo");
  // 3rd parameter to GlobalVariable is false because it is not a constant variable

  // sample code that loads values by de-referencing an array location
  llvm::Function *print_int = genPrintIntDef();
  llvm::Function *F = genMainDef();
  llvm::Value *ArrayLoc = Builder.CreateStructGEP(arrayi32, Foo, 0, "arrayloc");
  llvm::Value *Index = Builder.getInt32(8); // access Foo[8]
  llvm::Value *ArrayIndex = Builder.CreateGEP(Builder.getInt32Ty(), ArrayLoc, Index, "arrayindex");
  llvm::Value *ArrayStore = Builder.CreateStore(Builder.getInt32(1), ArrayIndex); // Foo[8] = 1
  llvm::Value *Value = Builder.CreateLoad(Builder.getInt32Ty(), ArrayIndex, "loadtmp");
  llvm::Value *addtmp = Builder.CreateAdd(Value, Builder.getInt32(1), "addtmp");
  llvm::Value *Store = Builder.CreateStore(addtmp, ArrayIndex); // Foo[8] = Foo[8] + 1
  llvm::Value *StoredValue = Builder.CreateLoad(Builder.getInt32Ty(), ArrayIndex, "loadtmp");
  llvm::Value *CallF = Builder.CreateCall(print_int, StoredValue);

  Builder.CreateRet(Builder.getInt32(0));
  llvm::verifyFunction(*F);
  TheModule->print(llvm::outs(), nullptr);
}

