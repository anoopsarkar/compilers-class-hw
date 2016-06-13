
declare void @print_int(i32)
declare void @print_string(i8*)
declare i32 @read_int()

@.nl = constant [2 x i8] c"\0A\00"

define i32 @add1(i32 %a, i32 %b) {
entry:
  %tmp1 = add i32 %a, %b
  ret i32 %tmp1
}

define i32 @add2(i32 %a, i32 %b) {
entry:
  %tmp1 = icmp eq i32 %a, 0
  br i1 %tmp1, label %done, label %recurse

recurse:
  %tmp2 = sub i32 %a, 1
  %tmp3 = add i32 %b, 1
  %tmp4 = call i32 @add2(i32 %tmp2, i32 %tmp3)
  ret i32 %tmp4

done:
  ret i32 %b
}

define i32 @main() {
entry:
  %tmp5 = call i32 @add2(i32 3, i32 4)
  call void @print_int(i32 %tmp5)
  %cast.nl = getelementptr [2 x i8], [2 x i8]* @.nl, i64 0, i64 0
  call void @print_string(i8* %cast.nl)
  ret i32 0
}

