; ModuleID = 'cminus'
source_filename = "/home/ethangao/workspace/USTC-Compiler-Engineering-2025/tests/2-ir-gen/autogen/testcases/lv1/iteration1.cminus"

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
  %op2 = icmp ne i32 %op1, 0
  br i1 %op2, label %label_while_loop, label %label_while_after
label_while_loop:                                                ; preds = %label_while_cond
  %op3 = load i32, i32* %op0
  call void @output(i32 %op3)
  %op4 = load i32, i32* %op0
  %op5 = sub i32 %op4, 1
  store i32 %op5, i32* %op0
  br label %label_while_cond
label_while_after:                                                ; preds = %label_while_cond
  ret void
}
