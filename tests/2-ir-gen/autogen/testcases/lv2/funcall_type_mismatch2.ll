; ModuleID = 'cminus'
source_filename = "/home/ethangao/workspace/USTC-Compiler-Engineering-2025/tests/2-ir-gen/autogen/testcases/lv2/funcall_type_mismatch2.cminus"

declare i32 @input()

declare void @output(i32)

declare void @outputFloat(float)

declare void @neg_idx_except()

define void @f(float %a) {
label_entry:
  %op0 = alloca float
  store float %a, float* %op0
  %op1 = load float, float* %op0
  call void @outputFloat(float %op1)
  ret void
}
define void @main() {
label_entry:
  %op0 = alloca i32
  %op1 = fptosi float 0x4012000000000000 to i32
  store i32 %op1, i32* %op0
  %op2 = load i32, i32* %op0
  %op3 = sitofp i32 %op2 to float
  call void @f(float %op3)
  ret void
}
