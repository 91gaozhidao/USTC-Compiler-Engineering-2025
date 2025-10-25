; ModuleID = 'cminus'
source_filename = "/home/ethangao/workspace/USTC-Compiler-Engineering-2025/tests/2-ir-gen/autogen/testcases/lv3/complex1.cminus"

declare i32 @input()

declare void @output(i32)

declare void @outputFloat(float)

declare void @neg_idx_except()

define i32 @mod(i32 %a, i32 %b) {
label_entry:
  %op0 = alloca i32
  store i32 %a, i32* %op0
  %op1 = alloca i32
  store i32 %b, i32* %op1
  %op2 = load i32, i32* %op0
  %op3 = load i32, i32* %op0
  %op4 = load i32, i32* %op1
  %op5 = sdiv i32 %op3, %op4
  %op6 = load i32, i32* %op1
  %op7 = mul i32 %op5, %op6
  %op8 = sub i32 %op2, %op7
  ret i32 %op8
}
define void @printfour(i32 %input) {
label_entry:
  %op0 = alloca i32
  store i32 %input, i32* %op0
  %op1 = alloca i32
  %op2 = alloca i32
  %op3 = alloca i32
  %op4 = alloca i32
  %op5 = load i32, i32* %op0
  %op6 = call i32 @mod(i32 %op5, i32 10000)
  store i32 %op6, i32* %op0
  %op7 = load i32, i32* %op0
  %op8 = call i32 @mod(i32 %op7, i32 10)
  store i32 %op8, i32* %op4
  %op9 = load i32, i32* %op0
  %op10 = sdiv i32 %op9, 10
  store i32 %op10, i32* %op0
  %op11 = load i32, i32* %op0
  %op12 = call i32 @mod(i32 %op11, i32 10)
  store i32 %op12, i32* %op3
  %op13 = load i32, i32* %op0
  %op14 = sdiv i32 %op13, 10
  store i32 %op14, i32* %op0
  %op15 = load i32, i32* %op0
  %op16 = call i32 @mod(i32 %op15, i32 10)
  store i32 %op16, i32* %op2
  %op17 = load i32, i32* %op0
  %op18 = sdiv i32 %op17, 10
  store i32 %op18, i32* %op0
  %op19 = load i32, i32* %op0
  store i32 %op19, i32* %op1
  %op20 = load i32, i32* %op1
  call void @output(i32 %op20)
  %op21 = load i32, i32* %op2
  call void @output(i32 %op21)
  %op22 = load i32, i32* %op3
  call void @output(i32 %op22)
  %op23 = load i32, i32* %op4
  call void @output(i32 %op23)
  ret void
}
define void @main() {
label_entry:
  %op0 = alloca [2801 x i32]
  %op1 = alloca i32
  %op2 = alloca i32
  %op3 = alloca i32
  %op4 = alloca i32
  %op5 = alloca i32
  store i32 0, i32* %op5
  store i32 1234, i32* %op4
  %op6 = alloca i32
  store i32 0, i32* %op6
  br label %label_while_cond
label_while_cond:                                                ; preds = %label_entry, %label13
  %op7 = load i32, i32* %op6
  %op8 = icmp slt i32 %op7, 2800
  %op9 = zext i1 %op8 to i32
  %op10 = icmp ne i32 %op9, 0
  br i1 %op10, label %label_while_loop, label %label_while_after
label_while_loop:                                                ; preds = %label_while_cond
  %op11 = load i32, i32* %op6
  %op12 = icmp sge i32 %op11, 0
  br i1 %op12, label %label13, label %label17
label_while_after:                                                ; preds = %label_while_cond
  store i32 2800, i32* %op2
  br label %label_while_cond
label13:                                                ; preds = %label_while_loop, %label17
  %op14 = getelementptr [2801 x i32], [2801 x i32]* %op0, i32 0, i32 %op11
  store i32 2000, i32* %op14
  %op15 = load i32, i32* %op6
  %op16 = add i32 %op15, 1
  store i32 %op16, i32* %op6
  br label %label_while_cond
label17:                                                ; preds = %label_while_loop
  call void @neg_idx_except()
  br label %label13
label_while_cond:                                                ; preds = %label_while_after, %label_while_after
  %op18 = load i32, i32* %op2
  %op19 = icmp ne i32 %op18, 0
  br i1 %op19, label %label_while_loop, label %label_while_after
label_while_loop:                                                ; preds = %label_while_cond
  %op20 = alloca i32
  store i32 0, i32* %op20
  %op21 = load i32, i32* %op2
  store i32 %op21, i32* %op1
  br label %label_while_cond
label_while_after:                                                ; preds = %label_while_cond
  ret void
label_while_cond:                                                ; preds = %label_while_loop, %label_contBB
  %op22 = load i32, i32* %op1
  %op23 = icmp ne i32 %op22, 0
  %op24 = zext i1 %op23 to i32
  %op25 = icmp ne i32 %op24, 0
  br i1 %op25, label %label_while_loop, label %label_while_after
label_while_loop:                                                ; preds = %label_while_cond
  %op26 = load i32, i32* %op20
  %op27 = load i32, i32* %op1
  %op28 = icmp sge i32 %op27, 0
  br i1 %op28, label %label37, label %label50
label_while_after:                                                ; preds = %label_while_cond
  %op29 = load i32, i32* %op5
  %op30 = load i32, i32* %op20
  %op31 = sdiv i32 %op30, 10000
  %op32 = add i32 %op29, %op31
  call void @printfour(i32 %op32)
  %op33 = load i32, i32* %op20
  %op34 = call i32 @mod(i32 %op33, i32 10000)
  store i32 %op34, i32* %op5
  %op35 = load i32, i32* %op2
  %op36 = sub i32 %op35, 14
  store i32 %op36, i32* %op2
  br label %label_while_cond
label37:                                                ; preds = %label_while_loop, %label50
  %op38 = getelementptr [2801 x i32], [2801 x i32]* %op0, i32 0, i32 %op27
  %op39 = load i32, i32* %op38
  %op40 = mul i32 %op39, 10000
  %op41 = add i32 %op26, %op40
  store i32 %op41, i32* %op20
  %op42 = load i32, i32* %op1
  %op43 = mul i32 2, %op42
  %op44 = sub i32 %op43, 1
  store i32 %op44, i32* %op3
  %op45 = load i32, i32* %op20
  %op46 = load i32, i32* %op3
  %op47 = call i32 @mod(i32 %op45, i32 %op46)
  %op48 = load i32, i32* %op1
  %op49 = icmp sge i32 %op48, 0
  br i1 %op49, label %label51, label %label62
label50:                                                ; preds = %label_while_loop
  call void @neg_idx_except()
  br label %label37
label51:                                                ; preds = %label37, %label62
  %op52 = getelementptr [2801 x i32], [2801 x i32]* %op0, i32 0, i32 %op48
  store i32 %op47, i32* %op52
  %op53 = load i32, i32* %op20
  %op54 = load i32, i32* %op3
  %op55 = sdiv i32 %op53, %op54
  store i32 %op55, i32* %op20
  %op56 = load i32, i32* %op1
  %op57 = sub i32 %op56, 1
  store i32 %op57, i32* %op1
  %op58 = load i32, i32* %op1
  %op59 = icmp ne i32 %op58, 0
  %op60 = zext i1 %op59 to i32
  %op61 = icmp ne i32 %op60, 0
  br i1 %op61, label %label_trueBB, label %label_contBB
label62:                                                ; preds = %label37
  call void @neg_idx_except()
  br label %label51
label_trueBB:                                                ; preds = %label51
  %op63 = load i32, i32* %op20
  %op64 = load i32, i32* %op1
  %op65 = mul i32 %op63, %op64
  store i32 %op65, i32* %op20
  br label %label_contBB
label_contBB:                                                ; preds = %label51, %label_trueBB
  br label %label_while_cond
}
