llvmconfig=llvm-config
b=`basename -s .ll $1`
`$llvmconfig --bindir`/llvm-as $1  # convert LLVM assembly to bitcode
`$llvmconfig --bindir`/llc $b.bc   # convert LLVM bitcode to x86 assembly
clang $b.s decaf-stdlib.c -o $b
./$b
rm -f $b.bc $b.s $b
