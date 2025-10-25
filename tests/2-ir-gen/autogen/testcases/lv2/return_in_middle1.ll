; ModuleID = 'cminus'
source_filename = "/home/ethangao/workspace/USTC-Compiler-Engineering-2025/tests/2-ir-gen/autogen/testcases/lv2/return_in_middle1.cminus"

declare i32 @input()

declare void @output(i32)

declare void @outputFloat(float)

declare void @neg_idx_except()

define i32 @result() {
label_entry:
  %op0 = alloca i32
  %op1 = icmp ne i32 1, 0
  br i1 %op1, label %label_trueBB, label %label_falseBB
label_trueBB:                                                ; preds = %label_entry
  store i32 1, i32* %op0
  ret i32 0
label_contBB:                                                ; preds = %label_falseBB
  call void @output(i32 3)
  ret i32 3
label_falseBB:                                                ; preds = %label_entry
  store i32 2, i32* %op0
  br label %label_contBB
}
define void @main() {
label_entry:
  %op0 = call i32 @result()
  call void @output(i32 %op0)
  ret void
}
