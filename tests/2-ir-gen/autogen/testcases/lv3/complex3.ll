; ModuleID = 'cminus'
source_filename = "/home/ethangao/workspace/USTC-Compiler-Engineering-2025/tests/2-ir-gen/autogen/testcases/lv3/complex3.cminus"

declare i32 @input()

declare void @output(i32)

declare void @outputFloat(float)

declare void @neg_idx_except()

define i32 @gcd(i32 %u, i32 %v) {
label_entry:
  %op0 = alloca i32
  store i32 %u, i32* %op0
  %op1 = alloca i32
  store i32 %v, i32* %op1
  %op2 = load i32, i32* %op1
  %op3 = icmp eq i32 %op2, 0
  %op4 = zext i1 %op3 to i32
  %op5 = icmp ne i32 %op4, 0
  br i1 %op5, label %label_trueBB, label %label_falseBB
label_trueBB:                                                ; preds = %label_entry
  %op6 = load i32, i32* %op0
  ret i32 %op6
label_falseBB:                                                ; preds = %label_entry
  %op7 = load i32, i32* %op1
  %op8 = load i32, i32* %op0
  %op9 = load i32, i32* %op0
  %op10 = load i32, i32* %op1
  %op11 = sdiv i32 %op9, %op10
  %op12 = load i32, i32* %op1
  %op13 = mul i32 %op11, %op12
  %op14 = sub i32 %op8, %op13
  %op15 = call i32 @gcd(i32 %op7, i32 %op14)
  ret i32 %op15
}
define void @main() {
label_entry:
  %op0 = alloca i32
  %op1 = alloca i32
  %op2 = alloca i32
  %op3 = call i32 @input()
  store i32 %op3, i32* %op0
  %op4 = call i32 @input()
  store i32 %op4, i32* %op1
  %op5 = load i32, i32* %op0
  %op6 = load i32, i32* %op1
  %op7 = icmp slt i32 %op5, %op6
  %op8 = zext i1 %op7 to i32
  %op9 = icmp ne i32 %op8, 0
  br i1 %op9, label %label_trueBB, label %label_contBB
label_trueBB:                                                ; preds = %label_entry
  %op10 = load i32, i32* %op0
  store i32 %op10, i32* %op2
  %op11 = load i32, i32* %op1
  store i32 %op11, i32* %op0
  %op12 = load i32, i32* %op2
  store i32 %op12, i32* %op1
  br label %label_contBB
label_contBB:                                                ; preds = %label_entry, %label_trueBB
  %op13 = load i32, i32* %op0
  %op14 = load i32, i32* %op1
  %op15 = call i32 @gcd(i32 %op13, i32 %op14)
  store i32 %op15, i32* %op2
  %op16 = load i32, i32* %op2
  call void @output(i32 %op16)
  ret void
}
