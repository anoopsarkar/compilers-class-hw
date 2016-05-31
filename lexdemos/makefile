
lexlib=l
bindir=.
rm=/bin/rm -f
targets=arithexp-re arithexp username lc vowelywords comments demo1 demo2 demo3 demo4 demo5 demo6 demo7 demo8 demo9 demo10 demo11 demo12 demo13 demo14 demo15 demo16 demo17 demo18

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

