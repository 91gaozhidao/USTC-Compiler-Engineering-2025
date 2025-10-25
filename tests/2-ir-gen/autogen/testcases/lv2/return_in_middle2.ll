; ModuleID = 'cminus'
source_filename = "/home/ethangao/workspace/USTC-Compiler-Engineering-2025/tests/2-ir-gen/autogen/testcases/lv2/return_in_middle2.cminus"

declare i32 @input()

declare void @output(i32)

declare void @outputFloat(float)

declare void @neg_idx_except()

define i32 @result() {
label_entry:
  %op0 = alloca i32
  store i32 10, i32* %op0
  br label %label_while_cond
label_while_cond:                                                ; preds = %label_entry
  %op1 = load i32, i32* %op0
  %op2 = icmp sgt i32 %op1, 0
  %op3 = zext i1 %op2 to i32
  %op4 = icmp ne i32 %op3, 0
  br i1 %op4, label %label_while_loop, label %label_while_after
label_while_loop:                                                ; preds = %label_while_cond
  ret i32 0
label_while_after:                                                ; preds = %label_while_cond
  call void @output(i32 4)
  ret i32 1
}
define void @main() {
label_entry:
  %op0 = call i32 @result()
  call void @output(i32 %op0)
  ret void
}
