
bindir=.
rm=/bin/rm -f
targets=
cpptargets=rmprefix

all: $(cpptargets)

$(cpptargets): %: %.cc
	@echo "compiling cpp file:" $<
	@echo "output file:" $@
	g++ -std=c++17 -o $(bindir)/$@ $<

clean:
	$(rm) $(targets) $(cpptargets)

