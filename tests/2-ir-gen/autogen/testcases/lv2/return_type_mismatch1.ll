; ModuleID = 'cminus'
source_filename = "/home/ethangao/workspace/USTC-Compiler-Engineering-2025/tests/2-ir-gen/autogen/testcases/lv2/return_type_mismatch1.cminus"

declare i32 @input()

declare void @output(i32)

declare void @outputFloat(float)

declare void @neg_idx_except()

define i32 @f() {
label_entry:
  %op0 = fptosi float 0x406d2999a0000000 to i32
  ret i32 %op0
}
define void @main() {
label_entry:
  %op0 = call i32 @f()
  call void @output(i32 %op0)
  ret void
}
