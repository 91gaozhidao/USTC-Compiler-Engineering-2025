; ModuleID = 'cminus'
source_filename = "/home/ethangao/workspace/USTC-Compiler-Engineering-2025/tests/2-ir-gen/autogen/testcases/lv2/funcall_float_array.cminus"

declare i32 @input()

declare void @output(i32)

declare void @outputFloat(float)

declare void @neg_idx_except()

define void @test(float* %a) {
label_entry:
  %op0 = alloca float*
  store float* %a, float** %op0
  %op1 = icmp sge i32 3, 0
  br i1 %op1, label %label2, label %label7
label2:                                                ; preds = %label_entry, %label7
  %op3 = load float*, float** %op0
  %op4 = getelementptr float, float* %op3, i32 3
  %op5 = load float, float* %op4
  %op6 = fptosi float %op5 to i32
  call void @output(i32 %op6)
  ret void
label7:                                                ; preds = %label_entry
  call void @neg_idx_except()
  br label %label2
}
define void @main() {
label_entry:
  %op0 = alloca [10 x float]
  %op1 = icmp sge i32 3, 0
  br i1 %op1, label %label2, label %label5
label2:                                                ; preds = %label_entry, %label5
  %op3 = getelementptr [10 x float], [10 x float]* %op0, i32 0, i32 3
  store float 0x40091eb860000000, float* %op3
  %op4 = getelementptr [10 x float], [10 x float]* %op0, i32 0, i32 0
  call void @test(float* %op4)
  ret void
label5:                                                ; preds = %label_entry
  call void @neg_idx_except()
  br label %label2
}
