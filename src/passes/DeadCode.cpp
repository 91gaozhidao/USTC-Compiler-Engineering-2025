#include "DeadCode.hpp"
#include "Instruction.hpp"
#include "logging.hpp"
#include <memory>
#include <vector>

// 处理流程：两趟处理，mark 标记有用变量，sweep 删除无用指令
void DeadCode::run() {
    bool changed{};
    func_info->run();
    do {
        changed = false;
        for (auto &F : m_->get_functions()) {
            auto func = &F;
            changed |= clear_basic_blocks(func);
            mark(func);
            changed |= sweep(func);
        }
    } while (changed);
    LOG_INFO << "dead code pass erased " << ins_count << " instructions";
}

bool DeadCode::clear_basic_blocks(Function *func) {
    bool changed = 0;
    std::vector<BasicBlock *> to_erase;
    for (auto &bb1 : func->get_basic_blocks()) {
        auto bb = &bb1;
        if (bb->get_pre_basic_blocks().empty() &&
            bb != func->get_entry_block()) {
            to_erase.push_back(bb);
            changed = 1;
        }
    }
    for (auto &bb : to_erase) {
        bb->erase_from_parent();
        delete bb;
    }
    return changed;
}

void DeadCode::mark(Function *func) {
    // 步骤 1: 清空之前的标记和工作列表
    marked.clear();
    work_list.clear();

    // 步骤 2: 找到所有关键（critical）指令，加入工作列表
    for (auto &bb : func->get_basic_blocks()) {
        for (auto &instr : bb.get_instructions()) {
            if (is_critical(&instr)) {
                // 标记为活指令（true 表示活的）
                marked[&instr] = true;
                work_list.push_back(&instr);
            }
        }
    }

    // 步骤 3: 使用工作列表算法传播"活性"
    // 从工作列表中取出指令，标记其所有操作数
    while (!work_list.empty()) {
        auto current_instr = work_list.front();
        work_list.pop_front();

        // 遍历当前指令的所有操作数
        for (auto operand : current_instr->get_operands()) {
            // 如果操作数是一条指令
            if (auto operand_instr = dynamic_cast<Instruction *>(operand)) {
                // 如果该指令还未被标记为活的
                if (marked.find(operand_instr) == marked.end() ||
                    marked[operand_instr] == false) {
                    // 标记为活指令
                    marked[operand_instr] = true;
                    work_list.push_back(operand_instr);
                }
            }
        }
    }
}

void DeadCode::mark(Instruction *ins) {
    // 递归标记单条指令及其所有依赖
    // 如果已经标记过，直接返回
    if (marked.find(ins) != marked.end() && marked[ins] == true) {
        return;
    }

    // 标记当前指令为活的
    marked[ins] = true;

    // 递归标记所有操作数（如果它们是指令）
    for (auto operand : ins->get_operands()) {
        if (auto operand_instr = dynamic_cast<Instruction *>(operand)) {
            mark(operand_instr);
        }
    }
}

bool DeadCode::sweep(Function *func) {
    // TODO: 删除无用指令
    // 提示：
    // 1. 遍历函数的基本块，删除所有标记为true的指令
    // 2.
    // 删除指令后，可能会导致其他指令的操作数变为无用，因此需要再次遍历函数的基本块
    // 3. 如果删除了指令，返回true，否则返回false
    // 4. 注意：删除指令时，需要先删除操作数的引用，然后再删除指令本身
    // 5. 删除指令时，需要注意指令的顺序，不能删除正在遍历的指令
    std::unordered_set<Instruction *> wait_del{};

    // 1. 收集所有未被标记的指令（死指令）
    for (auto &bb : func->get_basic_blocks()) {
        for (auto &instr : bb.get_instructions()) {
            // 如果指令未被标记，或者被标记为 false（死的）
            if (marked.find(&instr) == marked.end() ||
                marked[&instr] == false) {
                wait_del.insert(&instr);
            }
        }
    }

    // 2. 执行删除
    for (auto instr : wait_del) {
        // 从基本块中删除指令
        // erase_instr 会自动处理 use-def 链的维护
        instr->get_parent()->erase_instr(instr);
        ins_count++; // 统计删除的指令数
    }

    return not wait_del.empty(); // 如果删除了指令，返回 true
}

bool DeadCode::is_critical(Instruction *ins) {
    // TODO: 判断指令是否是无用指令
    // 提示：
    // 1. 如果是函数调用，且函数是纯函数，则无用
    // 2. 如果是无用的分支指令，则无用
    // 3. 如果是无用的返回指令，则无用
    // 4. 如果是无用的存储指令，则无用
    // 判断指令是否是关键（critical）指令
    // 关键指令是指那些有副作用或者必须执行的指令

    // 1. 返回指令（ret）必须保留
    if (ins->is_ret()) {
        return true;
    }

    // 2. 存储指令（store）有副作用，必须保留
    if (ins->is_store()) {
        return true;
    }

    // 3. 分支指令（br）控制程序流，必须保留
    if (ins->is_br()) {
        return true;
    }

    // 4. 函数调用需要特殊判断
    if (ins->is_call()) {
        auto call_inst = dynamic_cast<CallInst *>(ins);
        if (!call_inst) {
            return true; // 安全起见
        }

        // 获取被调用的函数（CallInst 的第一个操作数是函数）
        auto callee = dynamic_cast<Function *>(call_inst->get_operand(0));

        if (!callee) {
            // 如果无法确定被调用的函数（比如函数指针），保守起见认为是关键的
            return true;
        }

        // 如果函数不是纯函数（有副作用），则该调用是关键的
        if (!func_info->is_pure_function(callee)) {
            return true;
        }

        // 如果是纯函数，且返回值未被使用，则可以删除
        // 这个判断会在 mark 阶段通过 use-def 链自动处理
        return false;
    }

    // 5. alloca 指令分配栈空间，可能会被后续的 store 使用
    // 但如果其结果未被使用，会在 mark 阶段被识别为死代码
    // 所以这里不需要特殊处理

    // 6. 其他算术、逻辑、比较、load 等指令
    // 如果它们的结果未被使用，则不是关键的

    return false;
}

void DeadCode::sweep_globally() {
    std::vector<Function *> unused_funcs;
    std::vector<GlobalVariable *> unused_globals;
    for (auto &f_r : m_->get_functions()) {
        if (f_r.get_use_list().size() == 0 and f_r.get_name() != "main")
            unused_funcs.push_back(&f_r);
    }
    for (auto &glob_var_r : m_->get_global_variable()) {
        if (glob_var_r.get_use_list().size() == 0)
            unused_globals.push_back(&glob_var_r);
    }
    // changed |= unused_funcs.size() or unused_globals.size();
    for (auto func : unused_funcs)
        m_->get_functions().erase(func);
    for (auto glob : unused_globals)
        m_->get_global_variable().erase(glob);
}
