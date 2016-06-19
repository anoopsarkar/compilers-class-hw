llvmconfig=llvm-config-3.8
b=`basename -s .ll $1`
`$llvmconfig --bindir`/llvm-as $1
`$llvmconfig --bindir`/llc $b.bc
gcc $b.s decaf-stdlib.c -o $b
./$b
rm -f $b.bc $b.s $b
