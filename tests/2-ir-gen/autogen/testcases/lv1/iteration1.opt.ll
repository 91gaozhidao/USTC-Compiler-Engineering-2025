; ModuleID = 'cminus'
source_filename = "/home/ethangao/workspace/USTC-Compiler-Engineering-2025/tests/2-ir-gen/autogen/testcases/lv1/iteration1.cminus"

declare i32 @input()

declare void @output(i32)

declare void @outputFloat(float)

declare void @neg_idx_except()

define void @main() {
label_entry:
  br label %label_while_cond_0
label_while_cond_0:                                                ; preds = %label_entry, %label_while_loop_1
  %op0 = phi i32 [ 10, %label_entry ], [ %op2, %label_while_loop_1 ]
  %op1 = icmp ne i32 %op0, 0
  br i1 %op1, label %label_while_loop_1, label %label_while_after_2
label_while_loop_1:                                                ; preds = %label_while_cond_0
  call void @output(i32 %op0)
  %op2 = sub i32 %op0, 1
  br label %label_while_cond_0
label_while_after_2:                                                ; preds = %label_while_cond_0
  ret void
}
