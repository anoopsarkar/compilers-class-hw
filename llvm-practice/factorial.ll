
declare void @print_int(i32)
declare void @print_string(i8*)
declare i32 @read_int()

; store the newline as a string constant
; more specifically as a constant array containing i8 integers
@.nl = constant [2 x i8] c"\0A\00"

define i32 @factorial(i32 %a) {
entry:
  %tmp2 = icmp eq i32 %a, 0
  br i1 %tmp2, label %done, label %recurse
recurse:
  %tmp3 = sub i32 %a, 1
  %tmp4 = call i32 @factorial(i32 %tmp3)
  %tmp5 = mul i32 %tmp4, %a
  ret i32 %tmp5
done:
  ret i32 1
}

define i32 @main() {
entry:
  %tmp6 = call i32 @factorial(i32 11)
  call void @print_int(i32 %tmp6)
  ; convert the constant newline array into a pointer to i8 values
  ; using getelementptr, arg1 = @.nl, 
  ; arg2 = first element stored in @.nl which is of type [2 x i8]
  ; arg3 = the first element of the constant array
  ; getelementptr will return the pointer to the first element
  %cast.nl = getelementptr [2 x i8], [2 x i8]* @.nl, i8 0, i8 0
  call void @print_string(i8* %cast.nl)
  ret i32 0
}

