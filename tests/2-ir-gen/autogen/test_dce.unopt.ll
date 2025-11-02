; ModuleID = 'cminus'
source_filename = "/home/ethangao/workspace/USTC-Compiler-Engineering-2025/build/test.cminus"

declare i32 @input()

declare void @output(i32)

declare void @outputFloat(float)

declare void @neg_idx_except()

define void @test() {
label_entry:
  %op0 = alloca i32
  %op1 = alloca i32
  store i32 1, i32* %op0
  store i32 1, i32* %op1
  %op2 = sitofp i32 0 to float
  ret float %op2
}
