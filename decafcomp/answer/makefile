llvmconfig=llvm-config-8
cppflags=-Wno-deprecated-register
lexlib=l
yacclib=y
llvmlibs=-lz -lncurses -ldl -lpthread -fcxx-exceptions
mylibs=-l$(yacclib) -l$(lexlib) $(llvmlibs)
bindir=.
rm=/bin/rm -f
mv=/bin/mv -f
llvmcpp=
llvmfiles=
llvmtargets=decafcomp default

all: $(targets) $(cpptargets) $(llvmfiles) $(llvmtargets) $(llvmcpp)

$(targets): %: %.y
	@echo "compiling yacc file:" $<
	@echo "output file:" $@
	bison -o$@.tab.c -d $<
	flex -o$@.lex.c $@.lex
	clang -o $(bindir)/$@ $@.tab.c $@.lex.c $(mylibs)
	$(rm) $@.tab.c $@.tab.h $@.lex.c

$(cpptargets): %: %.y
	@echo "compiling cpp yacc file:" $<
	@echo "output file:" $@
	bison -b $@ -d $<
	$(mv) $@.tab.c $@.tab.cc
	flex -o$@.lex.cc $@.lex
	clang++ -std=c++11 -o $(bindir)/$@ $@.tab.cc $@.lex.cc $(mylibs)
	$(rm) $@.tab.h $@.tab.cc $@.lex.cc

$(llvmtargets): %: %.y
	@echo "compiling cpp yacc file:" $<
	@echo "output file:" $@
	bison -b $@ -d $<
	$(mv) $@.tab.c $@.tab.cc
	flex -o$@.lex.cc $@.lex
	clang -g -c decaf-stdlib.c
	clang++ $(cppflags) -o $(bindir)/$@ $@.tab.cc $@.lex.cc decaf-stdlib.o $(shell $(llvmconfig) --cxxflags --cppflags --cflags --ldflags --system-libs --libs core native) $(mylibs)
	$(rm) $@.tab.h $@.tab.cc $@.lex.cc 

$(llvmcpp): %: %.cc
	@echo "using llvm to compile file:" $<
	clang++ $(cppflags) -g $< $(shell $(llvmconfig) --cxxflags --cppflags --cflags --ldflags --system-libs --libs core native) $(llvmlibs) -O3 -o $(bindir)/$@

$(llvmfiles): %: %.ll
	@echo "using llvm to compile file:" $<
	$(shell $(llvmconfig) --bindir)/llvm-as $<
	$(shell $(llvmconfig) --bindir)/llc $@.bc
	clang $@.s decaf-stdlib.c -o $(bindir)/$@

test: $(targets) $(cpptargets)
	@echo "inherited attributes in yacc ..."
	echo "2 + 3 + 4" | $(bindir)/expr-inherit

clean:
	$(rm) $(targets) $(cpptargets) $(llvmtargets) $(llvmcpp) $(llvmfiles)
	$(rm) *.tab.h *.tab.c *.tab.cc *.lex.c *.lex.cc
	$(rm) *.bc *.s *.o
	$(rm) -r *.dSYM
