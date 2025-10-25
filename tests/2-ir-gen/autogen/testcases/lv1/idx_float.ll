; ModuleID = 'cminus'
source_filename = "/home/ethangao/workspace/USTC-Compiler-Engineering-2025/tests/2-ir-gen/autogen/testcases/lv1/idx_float.cminus"

declare i32 @input()

declare void @output(i32)

declare void @outputFloat(float)

declare void @neg_idx_except()

define void @main() {
label_entry:
  %op0 = alloca [10 x i32]
  %op1 = icmp sge i32 0, 0
  br i1 %op1, label %label2, label %label6
label2:                                                ; preds = %label_entry, %label6
  %op3 = getelementptr [10 x i32], [10 x i32]* %op0, i32 0, i32 0
  store i32 1024, i32* %op3
  %op4 = fptosi float 0x3fb99999a0000000 to i32
  %op5 = icmp sge i32 %op4, 0
  br i1 %op5, label %label7, label %label10
label6:                                                ; preds = %label_entry
  call void @neg_idx_except()
  br label %label2
label7:                                                ; preds = %label2, %label10
  %op8 = getelementptr [10 x i32], [10 x i32]* %op0, i32 0, i32 %op4
  %op9 = load i32, i32* %op8
  call void @output(i32 %op9)
  ret void
label10:                                                ; preds = %label2
  call void @neg_idx_except()
  br label %label7
}
