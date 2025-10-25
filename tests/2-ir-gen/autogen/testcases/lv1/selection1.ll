; ModuleID = 'cminus'
source_filename = "/home/ethangao/workspace/USTC-Compiler-Engineering-2025/tests/2-ir-gen/autogen/testcases/lv1/selection1.cminus"

declare i32 @input()

declare void @output(i32)

declare void @outputFloat(float)

declare void @neg_idx_except()

define void @main() {
label_entry:
  %op0 = alloca i32
  store i32 2, i32* %op0
  %op1 = load i32, i32* %op0
  %op2 = icmp ne i32 %op1, 0
  br i1 %op2, label %label_trueBB, label %label_contBB
label_trueBB:                                                ; preds = %label_entry
  call void @output(i32 42)
  br label %label_contBB
label_contBB:                                                ; preds = %label_entry, %label_trueBB
  call void @output(i32 24)
  ret void
}
