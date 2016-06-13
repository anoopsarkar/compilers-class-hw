b=`basename -s .ll $1`
llvm-as-3.8 $1
llc-3.8 $b.bc
gcc $b.s decaf-stdlib.c -o $b
./$b
rm -f $b.bc $b.s $b
