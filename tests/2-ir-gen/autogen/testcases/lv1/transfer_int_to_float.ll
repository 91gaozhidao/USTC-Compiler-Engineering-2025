; ModuleID = 'cminus'
source_filename = "/home/ethangao/workspace/USTC-Compiler-Engineering-2025/tests/2-ir-gen/autogen/testcases/lv1/transfer_int_to_float.cminus"

declare i32 @input()

declare void @output(i32)

declare void @outputFloat(float)

declare void @neg_idx_except()

define void @main() {
label_entry:
  %op0 = alloca float
  %op1 = sitofp i32 1 to float
  store float %op1, float* %op0
  %op2 = load float, float* %op0
  call void @outputFloat(float %op2)
  ret void
}
