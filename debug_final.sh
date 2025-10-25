#!/bin/bash

#
# 最终调试脚本 (文件输出版):
# 1. 运行所有测试用例，生成 .ll 文件。
# 2. 调用 clang 编译 .ll 文件。
# 3. 如果 clang 崩溃，则将导致崩溃的 .ll 文件内容追加到 crashed_ir_log.txt 文件中。
#

# --- 配置 ---
COMPILER="./build/cminusfc"
TEST_DIR="./tests/2-ir-gen"
CLANG="clang" # 或者您的 clang-14 路径
RUNTIME_LIB="./tests/2-ir-gen/autogen/lib.c"
LOG_FILE="crashed_ir_log.txt"

# --- 清理与初始化 ---
# 清理旧的编译产物
rm -f ${TEST_DIR}/autogen/testcases/*/*/*.ll
rm -f ${TEST_DIR}/autogen/testcases/*/*/*.o
rm -f ${TEST_DIR}/autogen/testcases/*/*/*.exe
# 清理旧的日志文件
rm -f "$LOG_FILE"

echo "开始进行最终调试..."
echo "如果发生崩溃，有问题的IR内容将被保存在当前目录的 $LOG_FILE 文件中。"
echo "------------------------------------------------------------------------"

# --- 脚本主体 ---
find "$TEST_DIR" -name "*.cminus" | sort | while read -r test_file; do
    
    # 1. 定义输出文件名
    output_ll_file="${test_file%.cminus}.ll"
    output_obj_file="${test_file%.cminus}.o"
    output_exe_file="${test_file%.cminus}.exe"

    # 2. 运行您的编译器，生成 .ll 文件
    "$COMPILER" "$test_file" -o "$output_ll_file" -emit-llvm
    if [ $? -ne 0 ]; then
        echo "[!!] 您的编译器 cminusfc 在处理 $test_file 时崩溃了"
        continue
    fi

    if [ ! -f "$output_ll_file" ]; then
        echo "[!!] 您的编译器 cminusfc 未能生成 $output_ll_file"
        continue
    fi

    # 3. 使用 clang 编译生成的 .ll 文件
    "$CLANG" -c -w "$output_ll_file" -o "$output_obj_file" > /dev/null 2>&1
    
    # 4. 检查 clang 是否崩溃
    if [ $? -ne 0 ]; then
        echo "[!!] Clang 崩溃于: $test_file -> 将IR写入 $LOG_FILE"
        
        # 使用一个命令组将所有输出重定向到日志文件
        {
            echo "========================================================================"
            echo "!!!!!! CLANG 在编译 $output_ll_file 时崩溃了 !!!!!!"
            echo "!!!!!! 以下是导致崩溃的 LLVM IR 内容 (带行号)：!!!!!!"
            echo "------------------------------------------------------------------------"
            cat -n "$output_ll_file"
            echo "------------------------------------------------------------------------"
            echo
            echo
        } >> "$LOG_FILE"
    else
        # 如果编译成功，则链接并清理
        "$CLANG" "$output_obj_file" "$RUNTIME_LIB" -o "$output_exe_file" > /dev/null 2>&1
        rm -f "$output_obj_file"
    fi

done

echo "------------------------------------------------------------------------"
echo "所有测试已运行完毕。"

if [ -f "$LOG_FILE" ]; then
    echo "检测到崩溃日志，文件 $LOG_FILE 已生成，请上传该文件。"
else
    echo "所有测试均未导致Clang崩溃。"
fi