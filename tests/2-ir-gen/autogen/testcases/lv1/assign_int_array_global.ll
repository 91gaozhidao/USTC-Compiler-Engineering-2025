; ModuleID = 'cminus'
source_filename = "/home/ethangao/workspace/USTC-Compiler-Engineering-2025/tests/2-ir-gen/autogen/testcases/lv1/assign_int_array_global.cminus"

@a = global [10 x i32] zeroinitializer
declare i32 @input()

declare void @output(i32)

declare void @outputFloat(float)

declare void @neg_idx_except()

define void @main() {
label_entry:
  %op0 = icmp sge i32 3, 0
  br i1 %op0, label %label1, label %label4
label1:                                                ; preds = %label_entry, %label4
  %op2 = getelementptr [10 x i32], [10 x i32]* @a, i32 0, i32 3
  store i32 1234, i32* %op2
  %op3 = icmp sge i32 3, 0
  br i1 %op3, label %label5, label %label8
label4:                                                ; preds = %label_entry
  call void @neg_idx_except()
  br label %label1
label5:                                                ; preds = %label1, %label8
  %op6 = getelementptr [10 x i32], [10 x i32]* @a, i32 0, i32 3
  %op7 = load i32, i32* %op6
  call void @output(i32 %op7)
  ret void
label8:                                                ; preds = %label1
  call void @neg_idx_except()
  br label %label5
}
