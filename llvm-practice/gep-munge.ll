%struct.munger_struct = type { i32, i32 }

define void @munge(ptr %P) {
entry:
  %tmp = getelementptr %struct.munger_struct, ptr %P, i32 1, i32 0
  %tmp1 = load i32, ptr %tmp
  %tmp2 = getelementptr %struct.munger_struct, ptr %P, i32 2, i32 1
  %tmp3 = load i32, ptr %tmp2
  %tmp4 = add i32 %tmp3, %tmp1
  %tmp5 = getelementptr %struct.munger_struct, ptr %P, i32 0, i32 0
  store i32 %tmp4, ptr %tmp5
  ret void
}

define i32 @main() {
  ret i32 0
}
