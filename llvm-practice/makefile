llvmconfig:=llvm-config
cc=clang
cpp=clang++
cppflags=-Wno-deprecated-register
lexlib=l
yacclib=y
llvmlibs=-lz -lncurses -ldl -lpthread -fcxx-exceptions
mylibs=-l$(yacclib) -l$(lexlib) $(llvmlibs)
bindir=.
rm=/bin/rm -f
mv=/bin/mv -f
llvmcpp=globalscalar globalarray kscope
llvmfiles=add helloworld factorial rec_add
llvmtargets=sexpr-codegen

all: $(targets) $(cpptargets) $(llvmfiles) $(llvmtargets) $(llvmcpp)

$(targets): %: %.y
	@echo "compiling yacc file:" $<
	@echo "output file:" $@
	bison -o$@.tab.c -d $<
	flex -o$@.lex.c $@.lex
	$(cc) -o $(bindir)/$@ $@.tab.c $@.lex.c $(mylibs)
	$(rm) $@.tab.c $@.tab.h $@.lex.c

$(cpptargets): %: %.y
	@echo "compiling cpp yacc file:" $<
	@echo "output file:" $@
	bison -b $@ -d $<
	$(mv) $@.tab.c $@.tab.cc
	flex -o$@.lex.cc $@.lex
	$(cpp) -std=c++11 -o $(bindir)/$@ $@.tab.cc $@.lex.cc $(mylibs)
	$(rm) $@.tab.h $@.tab.cc $@.lex.cc

$(llvmtargets): %: %.y
	@echo "compiling cpp yacc file:" $<
	@echo "output file:" $@
	bison -b $@ -d $<
	$(mv) $@.tab.c $@.tab.cc
	flex -o$@.lex.cc $@.lex
	$(cc) -g -c decaf-stdlib.c
	$(cpp) $(cppflags) -o $(bindir)/$@ $@.tab.cc $@.lex.cc decaf-stdlib.o $(shell $(llvmconfig) --cxxflags --cppflags --cflags --ldflags --libs core native) $(mylibs)
	$(rm) $@.tab.h $@.tab.cc $@.lex.cc 

$(llvmcpp): %: %.cc
	@echo "using llvm to compile file:" $<
	$(cpp) $(cppflags) -g $< $(shell $(llvmconfig) --cxxflags --cppflags --cflags --ldflags --libs core native) $(llvmlibs) -O3 -o $(bindir)/$@

$(llvmfiles): %: %.ll
	@echo "using llvm to compile file:" $<
	$(shell $(llvmconfig) --bindir)/llvm-as $<
	$(shell $(llvmconfig) --bindir)/llc $@.bc
	$(cc) $@.s decaf-stdlib.c -o $(bindir)/$@

clean:
	$(rm) $(targets) $(cpptargets) $(llvmtargets) $(llvmcpp) $(llvmfiles)
	$(rm) *.tab.h *.tab.c *.tab.cc *.lex.c *.lex.cc
	$(rm) *.bc *.s *.o
	$(rm) -r *.dSYM
