#include "ConstPropagation.hpp"

#include "Instruction.hpp"
#include "Module.hpp"
#include "logging.hpp"

ConstantInt *ConstFolder::compute(Instruction::OpID op, ConstantInt *value1,
                                  ConstantInt *value2) {
    int c_value1 = value1->get_value();
    int c_value2 = value2->get_value();

    switch (op) {
    case Instruction::add:
        return ConstantInt::get(c_value1 + c_value2, module_);
        break;
    case Instruction::sub:
        return ConstantInt::get(c_value1 - c_value2, module_);
        break;
    case Instruction::mul:
        return ConstantInt::get(c_value1 * c_value2, module_);
        break;
    case Instruction::sdiv:
        return ConstantInt::get(static_cast<int>(c_value1 / c_value2), module_);
        break;
    case Instruction::eq:
        return ConstantInt::get(c_value1 == c_value2, module_);
        break;
    case Instruction::ne:
        return ConstantInt::get(c_value1 != c_value2, module_);
        break;
    case Instruction::gt:
        return ConstantInt::get(c_value1 > c_value2, module_);
        break;
    case Instruction::ge:
        return ConstantInt::get(c_value1 >= c_value2, module_);
        break;
    case Instruction::lt:
        return ConstantInt::get(c_value1 < c_value2, module_);
        break;
    case Instruction::le:
        return ConstantInt::get(c_value1 <= c_value2, module_);
        break;
    default:
        return nullptr;
        break;
    }
}

ConstantFP *ConstFolder::compute(Instruction::OpID op, ConstantFP *value1,
                                 ConstantFP *value2) {
    float c_value1 = value1->get_value();
    float c_value2 = value2->get_value();
    switch (op) {
    case Instruction::fadd:
        return ConstantFP::get(c_value1 + c_value2, module_);
        break;
    case Instruction::fsub:
        return ConstantFP::get(c_value1 - c_value2, module_);
        break;
    case Instruction::fmul:
        return ConstantFP::get(c_value1 * c_value2, module_);
        break;
    case Instruction::fdiv:
        return ConstantFP::get(c_value1 / c_value2, module_);
        break;
    case Instruction::feq:
        return (ConstantFP *)ConstantInt::get(c_value1 == c_value2, module_);
        break;
    case Instruction::fne:
        return (ConstantFP *)ConstantInt::get(c_value1 != c_value2, module_);
        break;
    case Instruction::fgt:
        return (ConstantFP *)ConstantInt::get(c_value1 > c_value2, module_);
        break;
    case Instruction::fge:
        return (ConstantFP *)ConstantInt::get(c_value1 >= c_value2, module_);
        break;
    case Instruction::flt:
        return (ConstantFP *)ConstantInt::get(c_value1 < c_value2, module_);
        break;
    case Instruction::fle:
        return (ConstantFP *)ConstantInt::get(c_value1 <= c_value2, module_);
        break;
    default:
        return nullptr;
        break;
    }
}

ConstantFP *ConstFolder::compute(Instruction::OpID op, ConstantInt *value1) {
    int c_value1 = value1->get_value();

    switch (op) {
    case Instruction::sitofp:
        return ConstantFP::get((float)c_value1, module_);
        break;

    default:
        return nullptr;
        break;
    }
}

ConstantInt *ConstFolder::compute(Instruction::OpID op, ConstantFP *value1) {
    float c_value1 = value1->get_value();
    switch (op) {
    case Instruction::fptosi:
        return ConstantInt::get(static_cast<int>(c_value1), module_);
        break;

    default:
        return nullptr;
        break;
    }
}

ConstantFP *cast_constantfp(Value *value) {
    auto constant_fp_ptr = dynamic_cast<ConstantFP *>(value);
    if (constant_fp_ptr) {
        return constant_fp_ptr;
    }
    return nullptr;
}
ConstantInt *cast_constantint(Value *value) {
    auto constant_int_ptr = dynamic_cast<ConstantInt *>(value);
    if (constant_int_ptr) {
        return constant_int_ptr;
    }
    return nullptr;
}

void ConstPropagation::run() {
    // ========== 第一阶段：常量折叠 ==========
    for (auto &func : m_->get_functions()) {
        for (auto &bb : func.get_basic_blocks()) {
            wait_delete.clear();

            for (auto &instr : bb.get_instructions()) {
                // ===== 整数二元运算 =====
                if (instr.is_add() || instr.is_sub() || instr.is_mul() ||
                    instr.is_div()) {
                    auto value1 = cast_constantint(instr.get_operand(0));
                    auto value2 = cast_constantint(instr.get_operand(1));
                    if (value1 && value2) {
                        auto fold_const = folder->compute(
                            instr.get_instr_type(), value1, value2);
                        instr.replace_all_use_with(fold_const);
                        wait_delete.push_back(&instr);
                    }
                }
                // ===== 浮点数二元运算 =====
                else if (instr.is_fadd() || instr.is_fsub() ||
                         instr.is_fmul() || instr.is_fdiv()) {
                    auto value1 = cast_constantfp(instr.get_operand(0));
                    auto value2 = cast_constantfp(instr.get_operand(1));
                    if (value1 && value2) {
                        auto fold_const = folder->compute(
                            instr.get_instr_type(), value1, value2);
                        instr.replace_all_use_with(fold_const);
                        wait_delete.push_back(&instr);
                    }
                }
                // ===== 整数比较运算 =====
                else if (instr.is_cmp()) {
                    auto value1 = cast_constantint(instr.get_operand(0));
                    auto value2 = cast_constantint(instr.get_operand(1));
                    if (value1 && value2) {
                        auto fold_const = folder->compute(
                            instr.get_instr_type(), value1, value2);
                        instr.replace_all_use_with(fold_const);
                        wait_delete.push_back(&instr);
                    }
                }
                // ===== 浮点数比较运算 =====
                else if (instr.is_fcmp()) {
                    auto value1 = cast_constantfp(instr.get_operand(0));
                    auto value2 = cast_constantfp(instr.get_operand(1));
                    if (value1 && value2) {
                        auto fold_const = folder->compute(
                            instr.get_instr_type(), value1, value2);
                        instr.replace_all_use_with(fold_const);
                        wait_delete.push_back(&instr);
                    }
                }
                // ===== 类型转换：int -> float =====
                else if (instr.is_si2fp()) {
                    auto value1 = cast_constantint(instr.get_operand(0));
                    if (value1) {
                        auto fold_const =
                            folder->compute(instr.get_instr_type(), value1);
                        instr.replace_all_use_with(fold_const);
                        wait_delete.push_back(&instr);
                    }
                }
                // ===== 类型转换：float -> int =====
                else if (instr.is_fp2si()) {
                    auto value1 = cast_constantfp(instr.get_operand(0));
                    if (value1) {
                        auto fold_const =
                            folder->compute(instr.get_instr_type(), value1);
                        instr.replace_all_use_with(fold_const);
                        wait_delete.push_back(&instr);
                    }
                }
                // ===== zext 指令：i1 -> i32 =====
                else if (instr.is_zext()) {
                    auto value1 = cast_constantint(instr.get_operand(0));
                    if (value1) {
                        auto fold_const =
                            ConstantInt::get(value1->get_value(), m_);
                        instr.replace_all_use_with(fold_const);
                        wait_delete.push_back(&instr);
                    }
                }
            }

            globalvar_def.clear();
            for (auto instr : wait_delete) {
                bb.erase_instr(instr);
            }
        }
    }

    // ========== 第二阶段：处理常量条件分支 ==========
    for (auto &func : m_->get_functions()) {
        for (auto &bb : func.get_basic_blocks()) {
            // 检查终结指令是否是条件分支
            auto terminator = bb.get_terminator();
            if (terminator && terminator->is_br()) {
                auto br_inst = dynamic_cast<BranchInst *>(terminator);

                // 如果是条件分支
                if (br_inst->is_cond_br()) {
                    auto cond = br_inst->get_operand(0);
                    auto true_bb =
                        dynamic_cast<BasicBlock *>(br_inst->get_operand(1));
                    auto false_bb =
                        dynamic_cast<BasicBlock *>(br_inst->get_operand(2));

                    // 检查条件是否是常量
                    auto const_cond = cast_constantint(cond);
                    if (const_cond) {
                        BasicBlock *target_bb = nullptr;
                        BasicBlock *unused_bb = nullptr;

                        if (const_cond->get_value() != 0) {
                            target_bb = true_bb;
                            unused_bb = false_bb;
                        } else {
                            target_bb = false_bb;
                            unused_bb = true_bb;
                        }

                        // 先删除旧的条件跳转指令
                        bb.erase_instr(br_inst);

                        // 更新 CFG
                        unused_bb->remove_pre_basic_block(&bb);
                        bb.remove_succ_basic_block(unused_bb);

                        // 创建新的无条件跳转指令
                        auto new_br = BranchInst::create_br(target_bb, &bb);

                        // 标记不可达的基本块
                        delete_bb.push_back(unused_bb);

                        LOG(DEBUG)
                            << "Constant branch folding: bb " << bb.get_name()
                            << " always goes to " << target_bb->get_name();
                    }
                }
            }
        }

        // 删除不可达的基本块
        for (auto bb : delete_bb) {
            clear_blocks_recs(bb);
        }
        delete_bb.clear();
    }
}

bool ConstPropagation::is_entry(BasicBlock *bb) {
    // 检查 bb 是否是其父函数的入口块
    auto func = bb->get_parent();
    if (func == nullptr) {
        return false;
    }
    return func->get_entry_block() == bb;
}

void ConstPropagation::clear_blocks_recs(BasicBlock *start_bb) {
    auto func = start_bb->get_parent();
    if (func == nullptr) {
        LOG(ERROR) << "basic block-" << start_bb->get_name()
                   << " has no parent function";
    } else {
        auto prev_bb = start_bb->get_pre_basic_blocks();
        // start_bb has no previous bb and is not the entry of parent function
        if (prev_bb.size() == 0 && !is_entry(start_bb)) {
            func->remove(start_bb);
            auto succ_bb = start_bb->get_succ_basic_blocks();
            for (auto each_succ_bb : succ_bb) {
                std::vector<Instruction *> del_inst;
                for (auto &instr1 : each_succ_bb->get_instructions()) {
                    auto instr = &instr1;
                    if (instr->is_phi()) {
                        LOG(DEBUG)
                            << "Find a PHI instruction in the sucess node of "
                               "useless branch";
                        for (int i = 1; i < instr->get_num_operand(); i += 2) {
                            if (instr->get_operand(i) == start_bb &&
                                start_bb->get_pre_basic_blocks().size() <= 0) {
                                LOG(DEBUG) << "remove unuseful phi branch in "
                                              "the index of "
                                           << i - 1 << " and " << i;

                                instr->remove_operand(i - 1);
                                instr->remove_operand(i - 1);
                            }
                        }
                        int operands_num_phi = instr->get_num_operand();
                        if (operands_num_phi == 2) {
                            auto value = instr->get_operand(0);
                            instr->replace_all_use_with(
                                cast_constantint(value));
                            del_inst.push_back(instr);
                        }
                    }
                }
                for (auto instr : del_inst)
                    each_succ_bb->erase_instr(instr);
                clear_blocks_recs(each_succ_bb);
            }
        }
    }
}
