#!/bin/bash
rm -rf build
mkdir build && cd build && cmake .. && make -j && sudo make install
cd /home/ethangao/workspace/USTC-Compiler-Engineering/USTC-Compiler-Engineering-2025/tests/2-ir-gen/autogen
bash eval_lab2.sh
