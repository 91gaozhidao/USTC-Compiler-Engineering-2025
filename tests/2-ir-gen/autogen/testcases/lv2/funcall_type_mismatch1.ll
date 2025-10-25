; ModuleID = 'cminus'
source_filename = "/home/ethangao/workspace/USTC-Compiler-Engineering-2025/tests/2-ir-gen/autogen/testcases/lv2/funcall_type_mismatch1.cminus"

declare i32 @input()

declare void @output(i32)

declare void @outputFloat(float)

declare void @neg_idx_except()

define void @f(i32 %a) {
label_entry:
  %op0 = alloca i32
  store i32 %a, i32* %op0
  %op1 = load i32, i32* %op0
  call void @output(i32 %op1)
  ret void
}
define void @main() {
label_entry:
  %op0 = alloca float
  %op1 = sitofp i32 10 to float
  store float %op1, float* %op0
  %op2 = load float, float* %op0
  %op3 = fptosi float %op2 to i32
  call void @f(i32 %op3)
  ret void
}
