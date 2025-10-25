; ModuleID = 'cminus'
source_filename = "/home/ethangao/workspace/USTC-Compiler-Engineering-2025/tests/2-ir-gen/autogen/testcases/lv2/funcall_var.cminus"

declare i32 @input()

declare void @output(i32)

declare void @outputFloat(float)

declare void @neg_idx_except()

define void @test(i32 %a) {
label_entry:
  %op0 = alloca i32
  store i32 %a, i32* %op0
  %op1 = load i32, i32* %op0
  call void @output(i32 %op1)
  ret void
}
define void @main() {
label_entry:
  %op0 = alloca i32
  store i32 10, i32* %op0
  %op1 = load i32, i32* %op0
  call void @test(i32 %op1)
  ret void
}
