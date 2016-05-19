
lexlib=l
bindir=.
rm=/bin/rm -f
targets=rmcomments

all: $(targets)

$(targets): %: %.lex
	@echo "compiling lex file:" $<
	@echo "output file:" $@
	flex -o$@.c $<
	gcc -o $(bindir)/$@ $@.c -l$(lexlib)
	$(rm) $@.c

clean:
	$(rm) $(targets)
	$(rm) *.pyc

