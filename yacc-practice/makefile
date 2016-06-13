lexlib=l
yacclib=y
bindir=.
rm=/bin/rm -f
mv=/bin/mv -f
targets=simple-expr multexpr simple-varexpr varexpr expr-inherit marker-nojoy
cpptargets=usingcpp expr-interpreter type-inherit

all: $(targets) $(cpptargets)

$(targets): %: %.y
	@echo "compiling yacc file:" $<
	@echo "output file:" $@
	bison -o$@.tab.c -d $<
	flex -o$@.lex.c $@.lex
	gcc -w -o $(bindir)/$@ $@.tab.c $@.lex.c -l$(yacclib) -l$(lexlib)
	$(rm) $@.tab.c $@.tab.h $@.lex.c

$(cpptargets): %: %.y
	@echo "compiling cpp yacc file:" $<
	@echo "output file:" $@
	bison -b $@ -d $<
	$(mv) $@.tab.c $@.tab.cc
	flex -o$@.lex.cc $@.lex
	g++ -w -o $(bindir)/$@ $@.tab.cc $@.lex.cc -l$(yacclib) -l$(lexlib)
	$(rm) $@.tab.h $@.tab.cc $@.lex.cc

clean:
	$(rm) $(targets) $(cpptargets)
	$(rm) *.tab.h *.tab.c *.lex.c
	$(rm) *.pyc

