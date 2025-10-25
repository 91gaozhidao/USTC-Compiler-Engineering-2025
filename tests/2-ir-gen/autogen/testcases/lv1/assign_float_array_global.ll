; ModuleID = 'cminus'
source_filename = "/home/ethangao/workspace/USTC-Compiler-Engineering-2025/tests/2-ir-gen/autogen/testcases/lv1/assign_float_array_global.cminus"

@b = global [10 x float] zeroinitializer
declare i32 @input()

declare void @output(i32)

declare void @outputFloat(float)

declare void @neg_idx_except()

define void @main() {
label_entry:
  %op0 = icmp sge i32 3, 0
  br i1 %op0, label %label1, label %label4
label1:                                                ; preds = %label_entry, %label4
  %op2 = getelementptr [10 x float], [10 x float]* @b, i32 0, i32 3
  store float 0x4093480000000000, float* %op2
  %op3 = icmp sge i32 3, 0
  br i1 %op3, label %label5, label %label8
label4:                                                ; preds = %label_entry
  call void @neg_idx_except()
  br label %label1
label5:                                                ; preds = %label1, %label8
  %op6 = getelementptr [10 x float], [10 x float]* @b, i32 0, i32 3
  %op7 = load float, float* %op6
  call void @outputFloat(float %op7)
  ret void
label8:                                                ; preds = %label1
  call void @neg_idx_except()
  br label %label5
}
