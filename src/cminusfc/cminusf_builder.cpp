#include "cminusf_builder.hpp"
#include <string> // ** THE FINAL FIX - Part 2: Include <string> for std::to_string **

#define CONST_FP(num) ConstantFP::get((float)num, module.get())
#define CONST_INT(num) ConstantInt::get(num, module.get())
// types
Type *VOID_T;
Type *INT1_T;
Type *INT32_T;
Type *INT32PTR_T;
Type *FLOAT_T;
Type *FLOATPTR_T;

bool promote(IRBuilder *builder, Value **l_val_p, Value **r_val_p) {
    bool is_int = false;
    auto &l_val = *l_val_p;
    auto &r_val = *r_val_p;
    if (l_val->get_type() == r_val->get_type()) {
        is_int = l_val->get_type()->is_integer_type();
    } else {
        if (l_val->get_type()->is_integer_type()) {
            l_val = builder->create_sitofp(l_val, FLOAT_T);
        } else {
            r_val = builder->create_sitofp(r_val, FLOAT_T);
        }
    }
    return is_int;
}

Value* CminusfBuilder::visit(ASTProgram &node) {
    VOID_T = module->get_void_type();
    INT1_T = module->get_int1_type();
    INT32_T = module->get_int32_type();
    INT32PTR_T = module->get_int32_ptr_type();
    FLOAT_T = module->get_float_type();
    FLOATPTR_T = module->get_float_ptr_type();

    Value *ret_val = nullptr;
    for (auto &decl : node.declarations) {
        ret_val = decl->accept(*this);
    }
    return ret_val;
}

Value* CminusfBuilder::visit(ASTNum &node) {
    if (node.type == TYPE_INT) {
        return CONST_INT(node.i_val);
    }
    return CONST_FP(node.f_val);
}

Value* CminusfBuilder::visit(ASTVarDeclaration &node) {
    // TODO #1
    Type *var_type = (node.type == TYPE_INT) ? (Type *)INT32_T : (Type *)FLOAT_T;

    if (node.num != nullptr) { // Array
        auto *array_type = ArrayType::get(var_type, node.num->i_val);
        if (scope.in_global()) {
            auto *initializer = ConstantZero::get(array_type, module.get());
            auto *var = GlobalVariable::create(node.id, module.get(), array_type, false, initializer);
            scope.push(node.id, var);
        } else {
            auto *var = builder->create_alloca(array_type);
            scope.push(node.id, var);
        }
    } else { // Single variable
        if (scope.in_global()) {
            auto *initializer = ConstantZero::get(var_type, module.get());
            auto *var = GlobalVariable::create(node.id, module.get(), var_type, false, initializer);
            scope.push(node.id, var);
        } else {
            auto *var = builder->create_alloca(var_type);
            scope.push(node.id, var);
        }
    }
    return nullptr;
}

Value* CminusfBuilder::visit(ASTFunDeclaration &node) {
    FunctionType *fun_type;
    Type *ret_type;
    std::vector<Type *> param_types;
    if (node.type == TYPE_INT)
        ret_type = INT32_T;
    else if (node.type == TYPE_FLOAT)
        ret_type = FLOAT_T;
    else
        ret_type = VOID_T;

    for (auto &param : node.params) {
        if (param->type == TYPE_INT) {
            param_types.push_back(param->isarray ? INT32PTR_T : INT32_T);
        } else {
            param_types.push_back(param->isarray ? FLOATPTR_T : FLOAT_T);
        }
    }

    fun_type = FunctionType::get(ret_type, param_types);
    auto func = Function::create(fun_type, node.id, module.get());
    scope.push(node.id, func);
    context.func = func;
    auto funBB = BasicBlock::create(module.get(), "entry", func);
    builder->set_insert_point(funBB);
    scope.enter();
    context.pre_enter_scope = true;
    std::vector<Value *> args;
    for (auto &arg : func->get_args()) {
        args.push_back(&arg);
    }
    for (unsigned int i = 0; i < node.params.size(); ++i) {
        auto* param_i = node.params[i]->accept(*this);
        args[i]->set_name(node.params[i]->id);
        builder->create_store(args[i], param_i);
        scope.push(node.params[i]->id, param_i);
    }
    node.compound_stmt->accept(*this);
    
    // ** FINAL FIX - Part 1 **
    // The builder might be pointing to a terminated block.
    // We only add a return if the current block is valid AND not terminated.
    if (builder->get_insert_block() && !builder->get_insert_block()->is_terminated())
    {
        if (context.func->get_return_type()->is_void_type())
            builder->create_void_ret();
        else if (context.func->get_return_type()->is_float_type())
            builder->create_ret(CONST_FP(0.));
        else
            builder->create_ret(CONST_INT(0));
    }
    scope.exit();
    return nullptr;
}

Value* CminusfBuilder::visit(ASTParam &node) {
    // This is the "hidden" TODO #0.
    Type* param_type;
    if (node.type == TYPE_INT) {
        param_type = node.isarray ? INT32PTR_T : INT32_T;
    } else {
        param_type = node.isarray ? FLOATPTR_T : FLOAT_T;
    }
    return builder->create_alloca(param_type);
}

Value* CminusfBuilder::visit(ASTCompoundStmt &node) {
    // TODO #2
    bool is_func_body = context.pre_enter_scope;
    if (is_func_body) {
        context.pre_enter_scope = false;
    } else {
        scope.enter();
    }
    
    for (auto &decl : node.local_declarations) {
        decl->accept(*this);
    }

    for (auto &stmt : node.statement_list) {
        if (!builder->get_insert_block() || builder->get_insert_block()->is_terminated())
            break;
        stmt->accept(*this);
    }

    if (!is_func_body) {
        scope.exit();
    }
    return nullptr;
}

Value* CminusfBuilder::visit(ASTExpressionStmt &node) {
    if (node.expression != nullptr) {
        node.expression->accept(*this);
    }
    return nullptr;
}

Value* CminusfBuilder::visit(ASTSelectionStmt &node) {
    auto *ret_val = node.expression->accept(*this);
    
    // ** THE FINAL FIX - Part 3: Generate unique labels **
    auto trueBB = BasicBlock::create(module.get(), "trueBB_" + std::to_string(label_count++), context.func);
    BasicBlock *falseBB;
    auto contBB = BasicBlock::create(module.get(), "contBB_" + std::to_string(label_count++), context.func);

    Value *cond_val;
    if (ret_val->get_type()->is_integer_type()) {
        cond_val = builder->create_icmp_ne(ret_val, CONST_INT(0));
    } else {
        cond_val = builder->create_fcmp_ne(ret_val, CONST_FP(0.));
    }

    if (node.else_statement == nullptr) {
        falseBB = contBB;
    } else {
        falseBB = BasicBlock::create(module.get(), "falseBB_" + std::to_string(label_count++), context.func);
    }
    builder->create_cond_br(cond_val, trueBB, falseBB);
    
    builder->set_insert_point(trueBB);
    node.if_statement->accept(*this);
    if (builder->get_insert_block() && !builder->get_insert_block()->is_terminated()) {
        builder->create_br(contBB);
    }

    if (node.else_statement != nullptr) {
        builder->set_insert_point(falseBB);
        node.else_statement->accept(*this);
        if (builder->get_insert_block() && !builder->get_insert_block()->is_terminated()) {
            builder->create_br(contBB);
        }
    }

    if (contBB->get_pre_basic_blocks().empty()) {
        contBB->erase_from_parent();
    } else {
        builder->set_insert_point(contBB);
    }
    
    return nullptr;
}

Value* CminusfBuilder::visit(ASTIterationStmt &node) {
    // TODO #3
    // ** THE FINAL FIX - Part 4: Generate unique labels **
    auto condBB = BasicBlock::create(module.get(), "while_cond_" + std::to_string(label_count++), context.func);
    auto loopBB = BasicBlock::create(module.get(), "while_loop_" + std::to_string(label_count++), context.func);
    auto afterBB = BasicBlock::create(module.get(), "while_after_" + std::to_string(label_count++), context.func);

    if (builder->get_insert_block() && !builder->get_insert_block()->is_terminated()) {
        builder->create_br(condBB);
    }

    builder->set_insert_point(condBB);
    auto *cond_val = node.expression->accept(*this);
    if (cond_val->get_type()->is_integer_type()) {
        cond_val = builder->create_icmp_ne(cond_val, CONST_INT(0));
    } else {
        cond_val = builder->create_fcmp_ne(cond_val, CONST_FP(0.));
    }
    builder->create_cond_br(cond_val, loopBB, afterBB);

    builder->set_insert_point(loopBB);
    node.statement->accept(*this);
    if (builder->get_insert_block() && !builder->get_insert_block()->is_terminated()) {
        builder->create_br(condBB);
    }

    builder->set_insert_point(afterBB);
    return nullptr;
}

Value* CminusfBuilder::visit(ASTReturnStmt &node) {
    if (node.expression == nullptr) {
        builder->create_void_ret();
    } else {
        auto *fun_ret_type =
            context.func->get_function_type()->get_return_type();
        auto *ret_val = node.expression->accept(*this);
        if (fun_ret_type != ret_val->get_type()) {
            if (fun_ret_type->is_integer_type()) {
                ret_val = builder->create_fptosi(ret_val, INT32_T);
            } else {
                ret_val = builder->create_sitofp(ret_val, FLOAT_T);
            }
        }
        builder->create_ret(ret_val);
    }
    return nullptr;
}

Value* CminusfBuilder::visit(ASTVar &node) {
    Value* var = this->scope.find(node.id);
    if (var->is<Function>()) {
        return var;
    }
    
    Type* var_alloc_type;
    if (var->is<AllocaInst>()) {
        var_alloc_type = var->as<AllocaInst>()->get_alloca_type();
    } else { // GlobalVariable
        var_alloc_type = var->as<GlobalVariable>()->get_type()->get_pointer_element_type();
    }

    if(node.expression) { // Array access
        bool original_require_lvalue = context.require_lvalue;
        context.require_lvalue = false;
        auto idx = node.expression->accept(*this);
        context.require_lvalue = original_require_lvalue;

        if (idx->get_type()->is_float_type()) {
            idx = builder->create_fptosi(idx, INT32_T);
        } else if(idx->get_type()->is_int1_type()){
            idx = builder->create_zext(idx, INT32_T);
        }
        auto right_bb = BasicBlock::create(module.get(), "", context.func);
        auto wrong_bb = BasicBlock::create(module.get(), "", context.func);
        
        auto cond_neg = builder->create_icmp_ge(idx, CONST_INT(0));
        builder->create_cond_br(cond_neg,right_bb, wrong_bb);

        auto wrong = scope.find("neg_idx_except");
        builder->set_insert_point(wrong_bb);
        builder->create_call(wrong, {});
        if (!builder->get_insert_block()->is_terminated())
             builder->create_br(right_bb);
        builder->set_insert_point(right_bb);
        
        Value* elem_ptr;
        if(var_alloc_type->is_pointer_type()) {
            auto loaded_ptr = builder->create_load(var);
            elem_ptr = builder->create_gep(loaded_ptr,{idx});
        } else { // is_array_type
            elem_ptr = builder->create_gep(var,{CONST_INT(0),idx});
        }

        if(context.require_lvalue) {
            context.require_lvalue = false;
            return elem_ptr;
        } else {
            return builder->create_load(elem_ptr);
        }
    } else { // Simple variable access
        if (context.require_lvalue) {
            context.require_lvalue = false;
            return var;
        } else {
            if(var_alloc_type->is_array_type()){
                return builder->create_gep(var, {CONST_INT(0),CONST_INT(0)});
            } else {
                return builder->create_load(var);
            }
        }
    }
    return nullptr;
}

Value* CminusfBuilder::visit(ASTAssignExpression &node) {
    auto *expr_result = node.expression->accept(*this);
    context.require_lvalue = true;
    auto *var_addr = node.var->accept(*this);
    if (var_addr->get_type()->get_pointer_element_type() !=
        expr_result->get_type()) {
        if (expr_result->get_type() == INT32_T) {
            expr_result = builder->create_sitofp(expr_result, FLOAT_T);
        } else {
            expr_result = builder->create_fptosi(expr_result, INT32_T);
        }
    }
    builder->create_store(expr_result, var_addr);
    return expr_result;
}

Value* CminusfBuilder::visit(ASTSimpleExpression &node) {
    // TODO #4
    if (node.additive_expression_r == nullptr) {
        return node.additive_expression_l->accept(*this);
    }

    auto *l_val = node.additive_expression_l->accept(*this);
    auto *r_val = node.additive_expression_r->accept(*this);
    bool is_int = promote(&*builder, &l_val, &r_val);
    
    Value *cmp_val = nullptr;
    if (is_int) {
        switch (node.op) {
            case OP_EQ:  cmp_val = builder->create_icmp_eq(l_val, r_val); break;
            case OP_NEQ: cmp_val = builder->create_icmp_ne(l_val, r_val); break;
            case OP_LT:  cmp_val = builder->create_icmp_lt(l_val, r_val); break;
            case OP_LE:  cmp_val = builder->create_icmp_le(l_val, r_val); break;
            case OP_GT:  cmp_val = builder->create_icmp_gt(l_val, r_val); break;
            case OP_GE:  cmp_val = builder->create_icmp_ge(l_val, r_val); break;
        }
    } else {
        switch (node.op) {
            case OP_EQ:  cmp_val = builder->create_fcmp_eq(l_val, r_val); break;
            case OP_NEQ: cmp_val = builder->create_fcmp_ne(l_val, r_val); break;
            case OP_LT:  cmp_val = builder->create_fcmp_lt(l_val, r_val); break;
            case OP_LE:  cmp_val = builder->create_fcmp_le(l_val, r_val); break;
            case OP_GT:  cmp_val = builder->create_fcmp_gt(l_val, r_val); break;
            case OP_GE:  cmp_val = builder->create_fcmp_ge(l_val, r_val); break;
        }
    }
    return builder->create_zext(cmp_val, INT32_T);
}

Value* CminusfBuilder::visit(ASTAdditiveExpression &node) {
    if (node.additive_expression == nullptr) {
        return node.term->accept(*this);
    }

    auto *l_val = node.additive_expression->accept(*this);
    auto *r_val = node.term->accept(*this);
    bool is_int = promote(&*builder, &l_val, &r_val);
    Value *ret_val = nullptr;
    switch (node.op) {
    case OP_PLUS:
        if (is_int) {
            ret_val = builder->create_iadd(l_val, r_val);
        } else {
            ret_val = builder->create_fadd(l_val, r_val);
        }
        break;
    case OP_MINUS:
        if (is_int) {
            ret_val = builder->create_isub(l_val, r_val);
        } else {
            ret_val = builder->create_fsub(l_val, r_val);
        }
        break;
    }
    return ret_val;
}

Value* CminusfBuilder::visit(ASTTerm &node) {
    if (node.term == nullptr) {
        return node.factor->accept(*this);
    }

    auto *l_val = node.term->accept(*this);
    auto *r_val = node.factor->accept(*this);
    bool is_int = promote(&*builder, &l_val, &r_val);

    Value *ret_val = nullptr;
    switch (node.op) {
    case OP_MUL:
        if (is_int) {
            ret_val = builder->create_imul(l_val, r_val);
        } else {
            ret_val = builder->create_fmul(l_val, r_val);
        }
        break;
    case OP_DIV:
        if (is_int) {
            ret_val = builder->create_isdiv(l_val, r_val);
        } else {
            ret_val = builder->create_fdiv(l_val, r_val);
        }
        break;
    }
    return ret_val;
}

Value* CminusfBuilder::visit(ASTCall &node) {
    auto *func = dynamic_cast<Function *>(scope.find(node.id));
    std::vector<Value *> args;
    auto param_type = func->get_function_type()->param_begin();
    for (auto &arg : node.args) {
        auto *arg_val = arg->accept(*this);
        if (param_type != func->get_function_type()->param_end() && !arg_val->get_type()->is_pointer_type() &&
            *param_type != arg_val->get_type()) {
            if (arg_val->get_type()->is_integer_type()) {
                arg_val = builder->create_sitofp(arg_val, FLOAT_T);
            } else {
                arg_val = builder->create_fptosi(arg_val, INT32_T);
            }
        }
        args.push_back(arg_val);
        if(param_type != func->get_function_type()->param_end())
            param_type++;
    }

    return builder->create_call(static_cast<Function *>(func), args);
}