; ModuleID = 'cminus'
source_filename = "/home/ethangao/workspace/USTC-Compiler-Engineering-2025/tests/2-ir-gen/autogen/testcases/lv1/assign_float_array_local.cminus"

declare i32 @input()

declare void @output(i32)

declare void @outputFloat(float)

declare void @neg_idx_except()

define void @main() {
label_entry:
  %op0 = alloca [10 x float]
  %op1 = icmp sge i32 3, 0
  br i1 %op1, label %label2, label %label5
label2:                                                ; preds = %label_entry, %label5
  %op3 = getelementptr [10 x float], [10 x float]* %op0, i32 0, i32 3
  store float 0x4093480000000000, float* %op3
  %op4 = icmp sge i32 3, 0
  br i1 %op4, label %label6, label %label9
label5:                                                ; preds = %label_entry
  call void @neg_idx_except()
  br label %label2
label6:                                                ; preds = %label2, %label9
  %op7 = getelementptr [10 x float], [10 x float]* %op0, i32 0, i32 3
  %op8 = load float, float* %op7
  call void @outputFloat(float %op8)
  ret void
label9:                                                ; preds = %label2
  call void @neg_idx_except()
  br label %label6
}
