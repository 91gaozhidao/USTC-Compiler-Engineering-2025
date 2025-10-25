; ModuleID = 'cminus'
source_filename = "/home/ethangao/workspace/USTC-Compiler-Engineering-2025/tests/2-ir-gen/autogen/testcases/lv3/complex2.cminus"

@x = global [10 x float] zeroinitializer
declare i32 @input()

declare void @output(i32)

declare void @outputFloat(float)

declare void @neg_idx_except()

define i32 @minloc(float* %a, float %low, i32 %high) {
label_entry:
  %op0 = alloca float*
  store float* %a, float** %op0
  %op1 = alloca float
  store float %low, float* %op1
  %op2 = alloca i32
  store i32 %high, i32* %op2
  %op3 = alloca i32
  %op4 = alloca i32
  %op5 = alloca i32
  %op6 = load float, float* %op1
  %op7 = fptosi float %op6 to i32
  store i32 %op7, i32* %op5
  %op8 = load float, float* %op1
  %op9 = fptosi float %op8 to i32
  %op10 = icmp sge i32 %op9, 0
  br i1 %op10, label %label11, label %label20
label11:                                                ; preds = %label_entry, %label20
  %op12 = load float*, float** %op0
  %op13 = getelementptr float, float* %op12, i32 %op9
  %op14 = load float, float* %op13
  %op15 = fptosi float %op14 to i32
  store i32 %op15, i32* %op4
  %op16 = load float, float* %op1
  %op17 = sitofp i32 1 to float
  %op18 = fadd float %op16, %op17
  %op19 = fptosi float %op18 to i32
  store i32 %op19, i32* %op3
  br label %label_while_cond
label20:                                                ; preds = %label_entry
  call void @neg_idx_except()
  br label %label11
label_while_cond:                                                ; preds = %label11, %label_contBB
  %op21 = load i32, i32* %op3
  %op22 = load i32, i32* %op2
  %op23 = icmp slt i32 %op21, %op22
  %op24 = zext i1 %op23 to i32
  %op25 = icmp ne i32 %op24, 0
  br i1 %op25, label %label_while_loop, label %label_while_after
label_while_loop:                                                ; preds = %label_while_cond
  %op26 = load i32, i32* %op3
  %op27 = icmp sge i32 %op26, 0
  br i1 %op27, label %label29, label %label38
label_while_after:                                                ; preds = %label_while_cond
  %op28 = load i32, i32* %op5
  ret i32 %op28
label29:                                                ; preds = %label_while_loop, %label38
  %op30 = load float*, float** %op0
  %op31 = getelementptr float, float* %op30, i32 %op26
  %op32 = load float, float* %op31
  %op33 = load i32, i32* %op4
  %op34 = sitofp i32 %op33 to float
  %op35 = fcmp ult float %op32, %op34
  %op36 = zext i1 %op35 to i32
  %op37 = icmp ne i32 %op36, 0
  br i1 %op37, label %label_trueBB, label %label_contBB
label38:                                                ; preds = %label_while_loop
  call void @neg_idx_except()
  br label %label29
label_trueBB:                                                ; preds = %label29
  %op39 = load i32, i32* %op3
  %op40 = icmp sge i32 %op39, 0
  br i1 %op40, label %label43, label %label49
label_contBB:                                                ; preds = %label29, %label43
  %op41 = load i32, i32* %op3
  %op42 = add i32 %op41, 1
  store i32 %op42, i32* %op3
  br label %label_while_cond
label43:                                                ; preds = %label_trueBB, %label49
  %op44 = load float*, float** %op0
  %op45 = getelementptr float, float* %op44, i32 %op39
  %op46 = load float, float* %op45
  %op47 = fptosi float %op46 to i32
  store i32 %op47, i32* %op4
  %op48 = load i32, i32* %op3
  store i32 %op48, i32* %op5
  br label %label_contBB
label49:                                                ; preds = %label_trueBB
  call void @neg_idx_except()
  br label %label43
}
define void @sort(float* %a, i32 %low, float %high) {
label_entry:
  %op0 = alloca float*
  store float* %a, float** %op0
  %op1 = alloca i32
  store i32 %low, i32* %op1
  %op2 = alloca float
  store float %high, float* %op2
  %op3 = alloca i32
  %op4 = alloca i32
  %op5 = load i32, i32* %op1
  store i32 %op5, i32* %op3
  br label %label_while_cond
label_while_cond:                                                ; preds = %label_entry, %label45
  %op6 = load i32, i32* %op3
  %op7 = load float, float* %op2
  %op8 = sitofp i32 1 to float
  %op9 = fsub float %op7, %op8
  %op10 = sitofp i32 %op6 to float
  %op11 = fcmp ult float %op10, %op9
  %op12 = zext i1 %op11 to i32
  %op13 = icmp ne i32 %op12, 0
  br i1 %op13, label %label_while_loop, label %label_while_after
label_while_loop:                                                ; preds = %label_while_cond
  %op14 = alloca i32
  %op15 = load float*, float** %op0
  %op16 = load i32, i32* %op3
  %op17 = sitofp i32 %op16 to float
  %op18 = load float, float* %op2
  %op19 = fptosi float %op18 to i32
  %op20 = call i32 @minloc(float* %op15, float %op17, i32 %op19)
  store i32 %op20, i32* %op4
  %op21 = load i32, i32* %op4
  %op22 = icmp sge i32 %op21, 0
  br i1 %op22, label %label23, label %label30
label_while_after:                                                ; preds = %label_while_cond
  ret void
label23:                                                ; preds = %label_while_loop, %label30
  %op24 = load float*, float** %op0
  %op25 = getelementptr float, float* %op24, i32 %op21
  %op26 = load float, float* %op25
  %op27 = fptosi float %op26 to i32
  store i32 %op27, i32* %op14
  %op28 = load i32, i32* %op3
  %op29 = icmp sge i32 %op28, 0
  br i1 %op29, label %label31, label %label37
label30:                                                ; preds = %label_while_loop
  call void @neg_idx_except()
  br label %label23
label31:                                                ; preds = %label23, %label37
  %op32 = load float*, float** %op0
  %op33 = getelementptr float, float* %op32, i32 %op28
  %op34 = load float, float* %op33
  %op35 = load i32, i32* %op4
  %op36 = icmp sge i32 %op35, 0
  br i1 %op36, label %label38, label %label44
label37:                                                ; preds = %label23
  call void @neg_idx_except()
  br label %label31
label38:                                                ; preds = %label31, %label44
  %op39 = load float*, float** %op0
  %op40 = getelementptr float, float* %op39, i32 %op35
  store float %op34, float* %op40
  %op41 = load i32, i32* %op14
  %op42 = load i32, i32* %op3
  %op43 = icmp sge i32 %op42, 0
  br i1 %op43, label %label45, label %label51
label44:                                                ; preds = %label31
  call void @neg_idx_except()
  br label %label38
label45:                                                ; preds = %label38, %label51
  %op46 = load float*, float** %op0
  %op47 = getelementptr float, float* %op46, i32 %op42
  %op48 = sitofp i32 %op41 to float
  store float %op48, float* %op47
  %op49 = load i32, i32* %op3
  %op50 = add i32 %op49, 1
  store i32 %op50, i32* %op3
  br label %label_while_cond
label51:                                                ; preds = %label38
  call void @neg_idx_except()
  br label %label45
}
define void @main() {
label_entry:
  %op0 = alloca i32
  store i32 0, i32* %op0
  br label %label_while_cond
label_while_cond:                                                ; preds = %label_entry, %label10
  %op1 = load i32, i32* %op0
  %op2 = icmp slt i32 %op1, 10
  %op3 = zext i1 %op2 to i32
  %op4 = icmp ne i32 %op3, 0
  br i1 %op4, label %label_while_loop, label %label_while_after
label_while_loop:                                                ; preds = %label_while_cond
  %op5 = call i32 @input()
  %op6 = load i32, i32* %op0
  %op7 = icmp sge i32 %op6, 0
  br i1 %op7, label %label10, label %label15
label_while_after:                                                ; preds = %label_while_cond
  %op8 = getelementptr [10 x float], [10 x float]* @x, i32 0, i32 0
  %op9 = sitofp i32 10 to float
  call void @sort(float* %op8, i32 0, float %op9)
  store i32 0, i32* %op0
  br label %label_while_cond
label10:                                                ; preds = %label_while_loop, %label15
  %op11 = getelementptr [10 x float], [10 x float]* @x, i32 0, i32 %op6
  %op12 = sitofp i32 %op5 to float
  store float %op12, float* %op11
  %op13 = load i32, i32* %op0
  %op14 = add i32 %op13, 1
  store i32 %op14, i32* %op0
  br label %label_while_cond
label15:                                                ; preds = %label_while_loop
  call void @neg_idx_except()
  br label %label10
label_while_cond:                                                ; preds = %label_while_after, %label22
  %op16 = load i32, i32* %op0
  %op17 = icmp slt i32 %op16, 10
  %op18 = zext i1 %op17 to i32
  %op19 = icmp ne i32 %op18, 0
  br i1 %op19, label %label_while_loop, label %label_while_after
label_while_loop:                                                ; preds = %label_while_cond
  %op20 = load i32, i32* %op0
  %op21 = icmp sge i32 %op20, 0
  br i1 %op21, label %label22, label %label28
label_while_after:                                                ; preds = %label_while_cond
  ret void
label22:                                                ; preds = %label_while_loop, %label28
  %op23 = getelementptr [10 x float], [10 x float]* @x, i32 0, i32 %op20
  %op24 = load float, float* %op23
  %op25 = fptosi float %op24 to i32
  call void @output(i32 %op25)
  %op26 = load i32, i32* %op0
  %op27 = add i32 %op26, 1
  store i32 %op27, i32* %op0
  br label %label_while_cond
label28:                                                ; preds = %label_while_loop
  call void @neg_idx_except()
  br label %label22
}
