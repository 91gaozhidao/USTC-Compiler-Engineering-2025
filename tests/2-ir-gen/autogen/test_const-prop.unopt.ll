; ModuleID = 'cminus'
source_filename = "/home/ethangao/workspace/USTC-Compiler-Engineering-2025/build/test_const-prop.cminus"

declare i32 @input()

declare void @output(i32)

declare void @outputFloat(float)

declare void @neg_idx_except()

define i32 @main() {
label_entry:
  %op0 = alloca i32
  %op1 = alloca i32
  %op2 = add i32 5, 3
  store i32 %op2, i32* %op0
  %op3 = load i32, i32* %op0
  %op4 = mul i32 %op3, 2
  store i32 %op4, i32* %op1
  %op5 = load i32, i32* %op1
  %op6 = icmp sgt i32 %op5, 10
  %op7 = zext i1 %op6 to i32
  %op8 = icmp ne i32 %op7, 0
  br i1 %op8, label %label_trueBB_0, label %label_falseBB_2
label_trueBB_0:                                                ; preds = %label_entry
  ret i32 1
label_falseBB_2:                                                ; preds = %label_entry
  ret i32 0
}
