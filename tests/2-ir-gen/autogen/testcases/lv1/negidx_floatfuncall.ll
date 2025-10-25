; ModuleID = 'cminus'
source_filename = "/home/ethangao/workspace/USTC-Compiler-Engineering-2025/tests/2-ir-gen/autogen/testcases/lv1/negidx_floatfuncall.cminus"

declare i32 @input()

declare void @output(i32)

declare void @outputFloat(float)

declare void @neg_idx_except()

define float @test() {
label_entry:
  %op0 = alloca [10 x i32]
  %op1 = sub i32 2, 3
  %op2 = icmp sge i32 %op1, 0
  br i1 %op2, label %label3, label %label6
label3:                                                ; preds = %label_entry, %label6
  %op4 = getelementptr [10 x i32], [10 x i32]* %op0, i32 0, i32 %op1
  %op5 = load i32, i32* %op4
  ret float 0x4000000000000000
label6:                                                ; preds = %label_entry
  call void @neg_idx_except()
  br label %label3
}
define void @main() {
label_entry:
  %op0 = call float @test()
  ret void
}
