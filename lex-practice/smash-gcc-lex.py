"""
    python3 smash-gcc-lex.py [NUM]

    Generates a C program with an identifier string whose length is equal to NUM.
    Useful to check robustness of the lexical analyzer in various compilers.

    e.g. Run:

        python3 smash-gcc-lex.py | cc -xc -

    This may not actually produce an a.out file. Works (or not) with gcc or clang.

    Compare to flex by running:

        make smash-gcc-lex
        python3 smash-gcc-lex.py | ./smash-gcc-lex | cc -xc -

"""

import sys
if __name__ == "__main__":
  #n = sys.maxint / 100000000
  n = 1000000
  if len(sys.argv) > 1:
    n = int(sys.argv[1])
  #print("using n =", n, file=sys.stderr)
  sys.stdout.write("#include <stdio.h>\nint main() { int ")
  #for i in xrange(n): sys.stdout.write('x')
  sys.stdout.write('x' * n)
  sys.stdout.write(r' = 1; printf("yes\n"); }')
  print()
  #print("finished generating C code ...", file=sys.stderr)

