
lexlib=l
bindir=.
rm=/bin/rm -f
targets=matchre
cpptargets=

all: $(targets) $(cpptargets)

$(targets): %: %.lex
	@echo "compiling lex file:" $<
	@echo "output file:" $@
	flex -o$@.c $<
	gcc -o $(bindir)/$@ $@.c -l$(lexlib)
	$(rm) $@.c

$(cpptargets): %: %.lex
	@echo "compiling cpp lex file:" $<
	@echo "output file:" $@
	flex -o$@.cc $<
	g++ -o $(bindir)/$@ $@.cc -l$(lexlib)
	$(rm) $@.cc

clean:
	$(rm) $(targets) $(cpptargets)

