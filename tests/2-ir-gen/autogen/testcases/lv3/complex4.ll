; ModuleID = 'cminus'
source_filename = "/home/ethangao/workspace/USTC-Compiler-Engineering-2025/tests/2-ir-gen/autogen/testcases/lv3/complex4.cminus"

declare i32 @input()

declare void @output(i32)

declare void @outputFloat(float)

declare void @neg_idx_except()

define float @get(float* %a, i32 %x, i32 %y, i32 %row) {
label_entry:
  %op0 = alloca float*
  store float* %a, float** %op0
  %op1 = alloca i32
  store i32 %x, i32* %op1
  %op2 = alloca i32
  store i32 %y, i32* %op2
  %op3 = alloca i32
  store i32 %row, i32* %op3
  %op4 = load i32, i32* %op1
  %op5 = load i32, i32* %op3
  %op6 = mul i32 %op4, %op5
  %op7 = load i32, i32* %op2
  %op8 = add i32 %op6, %op7
  %op9 = icmp sge i32 %op8, 0
  br i1 %op9, label %label10, label %label14
label10:                                                ; preds = %label_entry, %label14
  %op11 = load float*, float** %op0
  %op12 = getelementptr float, float* %op11, i32 %op8
  %op13 = load float, float* %op12
  ret float %op13
label14:                                                ; preds = %label_entry
  call void @neg_idx_except()
  br label %label10
}
define float @abs(float %x) {
label_entry:
  %op0 = alloca float
  store float %x, float* %op0
  %op1 = load float, float* %op0
  %op2 = sitofp i32 0 to float
  %op3 = fcmp ugt float %op1, %op2
  %op4 = zext i1 %op3 to i32
  %op5 = icmp ne i32 %op4, 0
  br i1 %op5, label %label_trueBB, label %label_falseBB
label_trueBB:                                                ; preds = %label_entry
  %op6 = load float, float* %op0
  ret float %op6
label_falseBB:                                                ; preds = %label_entry
  %op7 = load float, float* %op0
  %op8 = sitofp i32 0 to float
  %op9 = fsub float %op8, %op7
  ret float %op9
}
define float @isZero(float %t) {
label_entry:
  %op0 = alloca float
  store float %t, float* %op0
  %op1 = load float, float* %op0
  %op2 = call float @abs(float %op1)
  %op3 = fcmp ult float %op2, 0x3eb0c6f7a0000000
  %op4 = zext i1 %op3 to i32
  %op5 = sitofp i32 %op4 to float
  ret float %op5
}
define i32 @gauss(float* %vars, float* %equ, i32 %var) {
label_entry:
  %op0 = alloca float*
  store float* %vars, float** %op0
  %op1 = alloca float*
  store float* %equ, float** %op1
  %op2 = alloca i32
  store i32 %var, i32* %op2
  %op3 = alloca i32
  %op4 = alloca i32
  %op5 = alloca i32
  %op6 = alloca i32
  %op7 = alloca i32
  %op8 = alloca i32
  %op9 = alloca float
  %op10 = load i32, i32* %op2
  %op11 = add i32 %op10, 1
  store i32 %op11, i32* %op6
  store i32 0, i32* %op3
  br label %label_while_cond
label_while_cond:                                                ; preds = %label_entry, %label19
  %op12 = load i32, i32* %op3
  %op13 = load i32, i32* %op2
  %op14 = icmp slt i32 %op12, %op13
  %op15 = zext i1 %op14 to i32
  %op16 = icmp ne i32 %op15, 0
  br i1 %op16, label %label_while_loop, label %label_while_after
label_while_loop:                                                ; preds = %label_while_cond
  %op17 = load i32, i32* %op3
  %op18 = icmp sge i32 %op17, 0
  br i1 %op18, label %label19, label %label25
label_while_after:                                                ; preds = %label_while_cond
  store i32 0, i32* %op8
  store i32 0, i32* %op5
  br label %label_while_cond
label19:                                                ; preds = %label_while_loop, %label25
  %op20 = load float*, float** %op0
  %op21 = getelementptr float, float* %op20, i32 %op17
  %op22 = sitofp i32 0 to float
  store float %op22, float* %op21
  %op23 = load i32, i32* %op3
  %op24 = add i32 %op23, 1
  store i32 %op24, i32* %op3
  br label %label_while_cond
label25:                                                ; preds = %label_while_loop
  call void @neg_idx_except()
  br label %label19
label_while_cond:                                                ; preds = %label_while_after, %label_contBB
  %op26 = load i32, i32* %op5
  %op27 = load i32, i32* %op2
  %op28 = icmp slt i32 %op26, %op27
  %op29 = zext i1 %op28 to i32
  %op30 = icmp ne i32 %op29, 0
  br i1 %op30, label %label_while_loop, label %label_while_after
label_while_loop:                                                ; preds = %label_while_cond
  %op31 = load i32, i32* %op5
  store i32 %op31, i32* %op7
  %op32 = load i32, i32* %op5
  %op33 = add i32 %op32, 1
  store i32 %op33, i32* %op3
  br label %label_while_cond
label_while_after:                                                ; preds = %label_while_cond
  %op34 = load i32, i32* %op2
  %op35 = sub i32 %op34, 1
  store i32 %op35, i32* %op3
  br label %label_while_cond
label_while_cond:                                                ; preds = %label_while_loop, %label_contBB
  %op36 = load i32, i32* %op3
  %op37 = load i32, i32* %op2
  %op38 = icmp slt i32 %op36, %op37
  %op39 = zext i1 %op38 to i32
  %op40 = icmp ne i32 %op39, 0
  br i1 %op40, label %label_while_loop, label %label_while_after
label_while_loop:                                                ; preds = %label_while_cond
  %op41 = load float*, float** %op1
  %op42 = load i32, i32* %op3
  %op43 = load i32, i32* %op8
  %op44 = load i32, i32* %op6
  %op45 = call float @get(float* %op41, i32 %op42, i32 %op43, i32 %op44)
  %op46 = call float @abs(float %op45)
  %op47 = load float*, float** %op1
  %op48 = load i32, i32* %op7
  %op49 = load i32, i32* %op8
  %op50 = load i32, i32* %op6
  %op51 = call float @get(float* %op47, i32 %op48, i32 %op49, i32 %op50)
  %op52 = call float @abs(float %op51)
  %op53 = fcmp ugt float %op46, %op52
  %op54 = zext i1 %op53 to i32
  %op55 = icmp ne i32 %op54, 0
  br i1 %op55, label %label_trueBB, label %label_contBB
label_while_after:                                                ; preds = %label_while_cond
  %op56 = load i32, i32* %op7
  %op57 = load i32, i32* %op5
  %op58 = icmp ne i32 %op56, %op57
  %op59 = zext i1 %op58 to i32
  %op60 = icmp ne i32 %op59, 0
  br i1 %op60, label %label_trueBB, label %label_contBB
label_trueBB:                                                ; preds = %label_while_loop
  %op61 = load i32, i32* %op3
  store i32 %op61, i32* %op7
  br label %label_contBB
label_contBB:                                                ; preds = %label_while_loop, %label_trueBB
  %op62 = load i32, i32* %op3
  %op63 = add i32 %op62, 1
  store i32 %op63, i32* %op3
  br label %label_while_cond
label_trueBB:                                                ; preds = %label_while_after
  %op64 = load i32, i32* %op5
  store i32 %op64, i32* %op4
  br label %label_while_cond
label_contBB:                                                ; preds = %label_while_after, %label_while_after
  %op65 = load float*, float** %op1
  %op66 = load i32, i32* %op5
  %op67 = load i32, i32* %op8
  %op68 = load i32, i32* %op6
  %op69 = call float @get(float* %op65, i32 %op66, i32 %op67, i32 %op68)
  %op70 = call float @isZero(float %op69)
  %op71 = fcmp une float %op70, 0x0
  br i1 %op71, label %label_trueBB, label %label_falseBB
label_while_cond:                                                ; preds = %label_trueBB, %label104
  %op72 = load i32, i32* %op4
  %op73 = load i32, i32* %op6
  %op74 = icmp slt i32 %op72, %op73
  %op75 = zext i1 %op74 to i32
  %op76 = icmp ne i32 %op75, 0
  br i1 %op76, label %label_while_loop, label %label_while_after
label_while_loop:                                                ; preds = %label_while_cond
  %op77 = load float*, float** %op1
  %op78 = load i32, i32* %op5
  %op79 = load i32, i32* %op4
  %op80 = load i32, i32* %op6
  %op81 = call float @get(float* %op77, i32 %op78, i32 %op79, i32 %op80)
  store float %op81, float* %op9
  %op82 = load float*, float** %op1
  %op83 = load i32, i32* %op7
  %op84 = load i32, i32* %op4
  %op85 = load i32, i32* %op6
  %op86 = call float @get(float* %op82, i32 %op83, i32 %op84, i32 %op85)
  %op87 = load i32, i32* %op5
  %op88 = load i32, i32* %op6
  %op89 = mul i32 %op87, %op88
  %op90 = load i32, i32* %op4
  %op91 = add i32 %op89, %op90
  %op92 = icmp sge i32 %op91, 0
  br i1 %op92, label %label93, label %label103
label_while_after:                                                ; preds = %label_while_cond
  br label %label_contBB
label93:                                                ; preds = %label_while_loop, %label103
  %op94 = load float*, float** %op1
  %op95 = getelementptr float, float* %op94, i32 %op91
  store float %op86, float* %op95
  %op96 = load float, float* %op9
  %op97 = load i32, i32* %op7
  %op98 = load i32, i32* %op6
  %op99 = mul i32 %op97, %op98
  %op100 = load i32, i32* %op4
  %op101 = add i32 %op99, %op100
  %op102 = icmp sge i32 %op101, 0
  br i1 %op102, label %label104, label %label109
label103:                                                ; preds = %label_while_loop
  call void @neg_idx_except()
  br label %label93
label104:                                                ; preds = %label93, %label109
  %op105 = load float*, float** %op1
  %op106 = getelementptr float, float* %op105, i32 %op101
  store float %op96, float* %op106
  %op107 = load i32, i32* %op4
  %op108 = add i32 %op107, 1
  store i32 %op108, i32* %op4
  br label %label_while_cond
label109:                                                ; preds = %label93
  call void @neg_idx_except()
  br label %label104
label_trueBB:                                                ; preds = %label_contBB
  %op110 = load i32, i32* %op5
  %op111 = sub i32 %op110, 1
  store i32 %op111, i32* %op5
  br label %label_contBB
label_contBB:                                                ; preds = %label_trueBB, %label_while_after
  %op112 = load i32, i32* %op5
  %op113 = add i32 %op112, 1
  store i32 %op113, i32* %op5
  %op114 = load i32, i32* %op8
  %op115 = add i32 %op114, 1
  store i32 %op115, i32* %op8
  br label %label_while_cond
label_falseBB:                                                ; preds = %label_contBB
  %op116 = load i32, i32* %op5
  %op117 = add i32 %op116, 1
  store i32 %op117, i32* %op3
  br label %label_while_cond
label_while_cond:                                                ; preds = %label_falseBB, %label_contBB
  %op118 = load i32, i32* %op3
  %op119 = load i32, i32* %op2
  %op120 = icmp slt i32 %op118, %op119
  %op121 = zext i1 %op120 to i32
  %op122 = icmp ne i32 %op121, 0
  br i1 %op122, label %label_while_loop, label %label_while_after
label_while_loop:                                                ; preds = %label_while_cond
  %op123 = load float*, float** %op1
  %op124 = load i32, i32* %op3
  %op125 = load i32, i32* %op8
  %op126 = load i32, i32* %op6
  %op127 = call float @get(float* %op123, i32 %op124, i32 %op125, i32 %op126)
  %op128 = call float @isZero(float %op127)
  %op129 = sitofp i32 1 to float
  %op130 = fsub float %op129, %op128
  %op131 = fcmp une float %op130, 0x0
  br i1 %op131, label %label_trueBB, label %label_contBB
label_while_after:                                                ; preds = %label_while_cond
  br label %label_contBB
label_trueBB:                                                ; preds = %label_while_loop
  %op132 = load float*, float** %op1
  %op133 = load i32, i32* %op3
  %op134 = load i32, i32* %op8
  %op135 = load i32, i32* %op6
  %op136 = call float @get(float* %op132, i32 %op133, i32 %op134, i32 %op135)
  %op137 = load float*, float** %op1
  %op138 = load i32, i32* %op5
  %op139 = load i32, i32* %op8
  %op140 = load i32, i32* %op6
  %op141 = call float @get(float* %op137, i32 %op138, i32 %op139, i32 %op140)
  %op142 = fdiv float %op136, %op141
  store float %op142, float* %op9
  %op143 = load i32, i32* %op8
  store i32 %op143, i32* %op4
  br label %label_while_cond
label_contBB:                                                ; preds = %label_while_loop, %label_while_after
  %op144 = load i32, i32* %op3
  %op145 = add i32 %op144, 1
  store i32 %op145, i32* %op3
  br label %label_while_cond
label_while_cond:                                                ; preds = %label_trueBB, %label176
  %op146 = load i32, i32* %op4
  %op147 = load i32, i32* %op6
  %op148 = icmp slt i32 %op146, %op147
  %op149 = zext i1 %op148 to i32
  %op150 = icmp ne i32 %op149, 0
  br i1 %op150, label %label_while_loop, label %label_while_after
label_while_loop:                                                ; preds = %label_while_cond
  %op151 = load i32, i32* %op3
  %op152 = load i32, i32* %op6
  %op153 = mul i32 %op151, %op152
  %op154 = load i32, i32* %op4
  %op155 = add i32 %op153, %op154
  %op156 = icmp sge i32 %op155, 0
  br i1 %op156, label %label157, label %label175
label_while_after:                                                ; preds = %label_while_cond
  br label %label_contBB
label157:                                                ; preds = %label_while_loop, %label175
  %op158 = load float*, float** %op1
  %op159 = getelementptr float, float* %op158, i32 %op155
  %op160 = load float, float* %op159
  %op161 = load float*, float** %op1
  %op162 = load i32, i32* %op5
  %op163 = load i32, i32* %op4
  %op164 = load i32, i32* %op6
  %op165 = call float @get(float* %op161, i32 %op162, i32 %op163, i32 %op164)
  %op166 = load float, float* %op9
  %op167 = fmul float %op165, %op166
  %op168 = fsub float %op160, %op167
  %op169 = load i32, i32* %op3
  %op170 = load i32, i32* %op6
  %op171 = mul i32 %op169, %op170
  %op172 = load i32, i32* %op4
  %op173 = add i32 %op171, %op172
  %op174 = icmp sge i32 %op173, 0
  br i1 %op174, label %label176, label %label181
label175:                                                ; preds = %label_while_loop
  call void @neg_idx_except()
  br label %label157
label176:                                                ; preds = %label157, %label181
  %op177 = load float*, float** %op1
  %op178 = getelementptr float, float* %op177, i32 %op173
  store float %op168, float* %op178
  %op179 = load i32, i32* %op4
  %op180 = add i32 %op179, 1
  store i32 %op180, i32* %op4
  br label %label_while_cond
label181:                                                ; preds = %label157
  call void @neg_idx_except()
  br label %label176
label_while_cond:                                                ; preds = %label_while_after, %label233
  %op182 = load i32, i32* %op3
  %op183 = icmp sge i32 %op182, 0
  %op184 = zext i1 %op183 to i32
  %op185 = icmp ne i32 %op184, 0
  br i1 %op185, label %label_while_loop, label %label_while_after
label_while_loop:                                                ; preds = %label_while_cond
  %op186 = load float*, float** %op1
  %op187 = load i32, i32* %op3
  %op188 = load i32, i32* %op2
  %op189 = load i32, i32* %op6
  %op190 = call float @get(float* %op186, i32 %op187, i32 %op188, i32 %op189)
  store float %op190, float* %op9
  %op191 = load i32, i32* %op3
  %op192 = add i32 %op191, 1
  store i32 %op192, i32* %op4
  br label %label_while_cond
label_while_after:                                                ; preds = %label_while_cond
  ret i32 0
label_while_cond:                                                ; preds = %label_while_loop, %label_contBB
  %op193 = load i32, i32* %op4
  %op194 = load i32, i32* %op2
  %op195 = icmp slt i32 %op193, %op194
  %op196 = zext i1 %op195 to i32
  %op197 = icmp ne i32 %op196, 0
  br i1 %op197, label %label_while_loop, label %label_while_after
label_while_loop:                                                ; preds = %label_while_cond
  %op198 = load float*, float** %op1
  %op199 = load i32, i32* %op3
  %op200 = load i32, i32* %op4
  %op201 = load i32, i32* %op6
  %op202 = call float @get(float* %op198, i32 %op199, i32 %op200, i32 %op201)
  %op203 = call float @isZero(float %op202)
  %op204 = sitofp i32 1 to float
  %op205 = fsub float %op204, %op203
  %op206 = fcmp une float %op205, 0x0
  br i1 %op206, label %label_trueBB, label %label_contBB
label_while_after:                                                ; preds = %label_while_cond
  %op207 = load float, float* %op9
  %op208 = load float*, float** %op1
  %op209 = load i32, i32* %op3
  %op210 = load i32, i32* %op3
  %op211 = load i32, i32* %op6
  %op212 = call float @get(float* %op208, i32 %op209, i32 %op210, i32 %op211)
  %op213 = fdiv float %op207, %op212
  %op214 = load i32, i32* %op3
  %op215 = icmp sge i32 %op214, 0
  br i1 %op215, label %label233, label %label238
label_trueBB:                                                ; preds = %label_while_loop
  %op216 = load float, float* %op9
  %op217 = load float*, float** %op1
  %op218 = load i32, i32* %op3
  %op219 = load i32, i32* %op4
  %op220 = load i32, i32* %op6
  %op221 = call float @get(float* %op217, i32 %op218, i32 %op219, i32 %op220)
  %op222 = load i32, i32* %op4
  %op223 = icmp sge i32 %op222, 0
  br i1 %op223, label %label226, label %label232
label_contBB:                                                ; preds = %label_while_loop, %label226
  %op224 = load i32, i32* %op4
  %op225 = add i32 %op224, 1
  store i32 %op225, i32* %op4
  br label %label_while_cond
label226:                                                ; preds = %label_trueBB, %label232
  %op227 = load float*, float** %op0
  %op228 = getelementptr float, float* %op227, i32 %op222
  %op229 = load float, float* %op228
  %op230 = fmul float %op221, %op229
  %op231 = fsub float %op216, %op230
  store float %op231, float* %op9
  br label %label_contBB
label232:                                                ; preds = %label_trueBB
  call void @neg_idx_except()
  br label %label226
label233:                                                ; preds = %label_while_after, %label238
  %op234 = load float*, float** %op0
  %op235 = getelementptr float, float* %op234, i32 %op214
  store float %op213, float* %op235
  %op236 = load i32, i32* %op3
  %op237 = sub i32 %op236, 1
  store i32 %op237, i32* %op3
  br label %label_while_cond
label238:                                                ; preds = %label_while_after
  call void @neg_idx_except()
  br label %label233
}
define void @main() {
label_entry:
  %op0 = alloca i32
  %op1 = alloca [3 x float]
  %op2 = alloca [12 x float]
  %op3 = icmp sge i32 0, 0
  br i1 %op3, label %label4, label %label8
label4:                                                ; preds = %label_entry, %label8
  %op5 = getelementptr [12 x float], [12 x float]* %op2, i32 0, i32 0
  %op6 = sitofp i32 1 to float
  store float %op6, float* %op5
  %op7 = icmp sge i32 1, 0
  br i1 %op7, label %label9, label %label13
label8:                                                ; preds = %label_entry
  call void @neg_idx_except()
  br label %label4
label9:                                                ; preds = %label4, %label13
  %op10 = getelementptr [12 x float], [12 x float]* %op2, i32 0, i32 1
  %op11 = sitofp i32 2 to float
  store float %op11, float* %op10
  %op12 = icmp sge i32 2, 0
  br i1 %op12, label %label14, label %label18
label13:                                                ; preds = %label4
  call void @neg_idx_except()
  br label %label9
label14:                                                ; preds = %label9, %label18
  %op15 = getelementptr [12 x float], [12 x float]* %op2, i32 0, i32 2
  %op16 = sitofp i32 1 to float
  store float %op16, float* %op15
  %op17 = icmp sge i32 3, 0
  br i1 %op17, label %label19, label %label25
label18:                                                ; preds = %label9
  call void @neg_idx_except()
  br label %label14
label19:                                                ; preds = %label14, %label25
  %op20 = getelementptr [12 x float], [12 x float]* %op2, i32 0, i32 3
  %op21 = sitofp i32 1 to float
  store float %op21, float* %op20
  %op22 = mul i32 1, 4
  %op23 = add i32 %op22, 0
  %op24 = icmp sge i32 %op23, 0
  br i1 %op24, label %label26, label %label32
label25:                                                ; preds = %label14
  call void @neg_idx_except()
  br label %label19
label26:                                                ; preds = %label19, %label32
  %op27 = getelementptr [12 x float], [12 x float]* %op2, i32 0, i32 %op23
  %op28 = sitofp i32 2 to float
  store float %op28, float* %op27
  %op29 = mul i32 1, 4
  %op30 = add i32 %op29, 1
  %op31 = icmp sge i32 %op30, 0
  br i1 %op31, label %label33, label %label39
label32:                                                ; preds = %label19
  call void @neg_idx_except()
  br label %label26
label33:                                                ; preds = %label26, %label39
  %op34 = getelementptr [12 x float], [12 x float]* %op2, i32 0, i32 %op30
  %op35 = sitofp i32 3 to float
  store float %op35, float* %op34
  %op36 = mul i32 1, 4
  %op37 = add i32 %op36, 2
  %op38 = icmp sge i32 %op37, 0
  br i1 %op38, label %label40, label %label46
label39:                                                ; preds = %label26
  call void @neg_idx_except()
  br label %label33
label40:                                                ; preds = %label33, %label46
  %op41 = getelementptr [12 x float], [12 x float]* %op2, i32 0, i32 %op37
  %op42 = sitofp i32 4 to float
  store float %op42, float* %op41
  %op43 = mul i32 1, 4
  %op44 = add i32 %op43, 3
  %op45 = icmp sge i32 %op44, 0
  br i1 %op45, label %label47, label %label53
label46:                                                ; preds = %label33
  call void @neg_idx_except()
  br label %label40
label47:                                                ; preds = %label40, %label53
  %op48 = getelementptr [12 x float], [12 x float]* %op2, i32 0, i32 %op44
  %op49 = sitofp i32 3 to float
  store float %op49, float* %op48
  %op50 = mul i32 2, 4
  %op51 = add i32 %op50, 0
  %op52 = icmp sge i32 %op51, 0
  br i1 %op52, label %label54, label %label60
label53:                                                ; preds = %label40
  call void @neg_idx_except()
  br label %label47
label54:                                                ; preds = %label47, %label60
  %op55 = getelementptr [12 x float], [12 x float]* %op2, i32 0, i32 %op51
  %op56 = sitofp i32 1 to float
  store float %op56, float* %op55
  %op57 = mul i32 2, 4
  %op58 = add i32 %op57, 1
  %op59 = icmp sge i32 %op58, 0
  br i1 %op59, label %label61, label %label68
label60:                                                ; preds = %label47
  call void @neg_idx_except()
  br label %label54
label61:                                                ; preds = %label54, %label68
  %op62 = getelementptr [12 x float], [12 x float]* %op2, i32 0, i32 %op58
  %op63 = sitofp i32 1 to float
  store float %op63, float* %op62
  %op64 = sub i32 0, 2
  %op65 = mul i32 2, 4
  %op66 = add i32 %op65, 2
  %op67 = icmp sge i32 %op66, 0
  br i1 %op67, label %label69, label %label75
label68:                                                ; preds = %label54
  call void @neg_idx_except()
  br label %label61
label69:                                                ; preds = %label61, %label75
  %op70 = getelementptr [12 x float], [12 x float]* %op2, i32 0, i32 %op66
  %op71 = sitofp i32 %op64 to float
  store float %op71, float* %op70
  %op72 = mul i32 2, 4
  %op73 = add i32 %op72, 3
  %op74 = icmp sge i32 %op73, 0
  br i1 %op74, label %label76, label %label82
label75:                                                ; preds = %label61
  call void @neg_idx_except()
  br label %label69
label76:                                                ; preds = %label69, %label82
  %op77 = getelementptr [12 x float], [12 x float]* %op2, i32 0, i32 %op73
  %op78 = sitofp i32 0 to float
  store float %op78, float* %op77
  %op79 = getelementptr [3 x float], [3 x float]* %op1, i32 0, i32 0
  %op80 = getelementptr [12 x float], [12 x float]* %op2, i32 0, i32 0
  %op81 = call i32 @gauss(float* %op79, float* %op80, i32 3)
  store i32 0, i32* %op0
  br label %label_while_cond
label82:                                                ; preds = %label69
  call void @neg_idx_except()
  br label %label76
label_while_cond:                                                ; preds = %label76, %label89
  %op83 = load i32, i32* %op0
  %op84 = icmp slt i32 %op83, 3
  %op85 = zext i1 %op84 to i32
  %op86 = icmp ne i32 %op85, 0
  br i1 %op86, label %label_while_loop, label %label_while_after
label_while_loop:                                                ; preds = %label_while_cond
  %op87 = load i32, i32* %op0
  %op88 = icmp sge i32 %op87, 0
  br i1 %op88, label %label89, label %label94
label_while_after:                                                ; preds = %label_while_cond
  ret void
label89:                                                ; preds = %label_while_loop, %label94
  %op90 = getelementptr [3 x float], [3 x float]* %op1, i32 0, i32 %op87
  %op91 = load float, float* %op90
  call void @outputFloat(float %op91)
  %op92 = load i32, i32* %op0
  %op93 = add i32 %op92, 1
  store i32 %op93, i32* %op0
  br label %label_while_cond
label94:                                                ; preds = %label_while_loop
  call void @neg_idx_except()
  br label %label89
}
