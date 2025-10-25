; ModuleID = 'cminus'
source_filename = "/home/ethangao/workspace/USTC-Compiler-Engineering-2025/tests/2-ir-gen/autogen/testcases/lv2/funcall_array_array.cminus"

declare i32 @input()

declare void @output(i32)

declare void @outputFloat(float)

declare void @neg_idx_except()

define void @g(i32* %b) {
label_entry:
  %op0 = alloca i32*
  store i32* %b, i32** %op0
  %op1 = icmp sge i32 3, 0
  br i1 %op1, label %label2, label %label6
label2:                                                ; preds = %label_entry, %label6
  %op3 = load i32*, i32** %op0
  %op4 = getelementptr i32, i32* %op3, i32 3
  %op5 = load i32, i32* %op4
  call void @output(i32 %op5)
  ret void
label6:                                                ; preds = %label_entry
  call void @neg_idx_except()
  br label %label2
}
define void @f(i32* %c) {
label_entry:
  %op0 = alloca i32*
  store i32* %c, i32** %op0
  %op1 = icmp sge i32 3, 0
  br i1 %op1, label %label2, label %label7
label2:                                                ; preds = %label_entry, %label7
  %op3 = load i32*, i32** %op0
  %op4 = getelementptr i32, i32* %op3, i32 3
  %op5 = load i32, i32* %op4
  call void @output(i32 %op5)
  %op6 = load i32*, i32** %op0
  call void @g(i32* %op6)
  ret void
label7:                                                ; preds = %label_entry
  call void @neg_idx_except()
  br label %label2
}
define void @main() {
label_entry:
  %op0 = alloca [10 x i32]
  %op1 = icmp sge i32 3, 0
  br i1 %op1, label %label2, label %label5
label2:                                                ; preds = %label_entry, %label5
  %op3 = getelementptr [10 x i32], [10 x i32]* %op0, i32 0, i32 3
  store i32 1024, i32* %op3
  %op4 = getelementptr [10 x i32], [10 x i32]* %op0, i32 0, i32 0
  call void @f(i32* %op4)
  ret void
label5:                                                ; preds = %label_entry
  call void @neg_idx_except()
  br label %label2
}
