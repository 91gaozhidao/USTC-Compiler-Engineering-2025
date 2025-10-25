; ModuleID = 'cminus'
source_filename = "/home/ethangao/workspace/USTC-Compiler-Engineering-2025/tests/2-ir-gen/autogen/testcases/lv1/iteration2.cminus"

declare i32 @input()

declare void @output(i32)

declare void @outputFloat(float)

declare void @neg_idx_except()

define void @main() {
label_entry:
  %op0 = alloca i32
  store i32 10, i32* %op0
  br label %label_while_cond
label_while_cond:                                                ; preds = %label_entry, %label_while_loop
  %op1 = load i32, i32* %op0
  %op2 = icmp sgt i32 %op1, 0
  %op3 = zext i1 %op2 to i32
  %op4 = icmp ne i32 %op3, 0
  br i1 %op4, label %label_while_loop, label %label_while_after
label_while_loop:                                                ; preds = %label_while_cond
  %op5 = load i32, i32* %op0
  call void @output(i32 %op5)
  %op6 = load i32, i32* %op0
  %op7 = sub i32 %op6, 1
  store i32 %op7, i32* %op0
  br label %label_while_cond
label_while_after:                                                ; preds = %label_while_cond
  ret void
}
