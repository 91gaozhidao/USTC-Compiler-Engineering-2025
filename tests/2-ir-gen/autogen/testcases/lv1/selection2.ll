; ModuleID = 'cminus'
source_filename = "/home/ethangao/workspace/USTC-Compiler-Engineering-2025/tests/2-ir-gen/autogen/testcases/lv1/selection2.cminus"

declare i32 @input()

declare void @output(i32)

declare void @outputFloat(float)

declare void @neg_idx_except()

define void @main() {
label_entry:
  %op0 = icmp sgt i32 2, 1
  %op1 = zext i1 %op0 to i32
  %op2 = icmp ne i32 %op1, 0
  br i1 %op2, label %label_trueBB, label %label_contBB
label_trueBB:                                                ; preds = %label_entry
  call void @output(i32 42)
  br label %label_contBB
label_contBB:                                                ; preds = %label_entry, %label_trueBB
  call void @output(i32 24)
  %op3 = icmp sgt i32 1, 2
  %op4 = zext i1 %op3 to i32
  %op5 = icmp ne i32 %op4, 0
  br i1 %op5, label %label_trueBB, label %label_contBB
label_trueBB:                                                ; preds = %label_contBB
  call void @output(i32 1234)
  br label %label_contBB
label_contBB:                                                ; preds = %label_contBB, %label_trueBB
  ret void
}
