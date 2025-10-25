; ModuleID = 'cminus'
source_filename = "/home/ethangao/workspace/USTC-Compiler-Engineering-2025/tests/2-ir-gen/autogen/testcases/lv1/negidx_float.cminus"

declare i32 @input()

declare void @output(i32)

declare void @outputFloat(float)

declare void @neg_idx_except()

define void @main() {
label_entry:
  %op0 = alloca [10 x i32]
  %op1 = sitofp i32 3 to float
  %op2 = fsub float 0x4000000000000000, %op1
  %op3 = fptosi float %op2 to i32
  %op4 = icmp sge i32 %op3, 0
  br i1 %op4, label %label5, label %label8
label5:                                                ; preds = %label_entry, %label8
  %op6 = getelementptr [10 x i32], [10 x i32]* %op0, i32 0, i32 %op3
  %op7 = load i32, i32* %op6
  ret void
label8:                                                ; preds = %label_entry
  call void @neg_idx_except()
  br label %label5
}
