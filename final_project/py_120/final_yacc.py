import ply.yacc as yacc
from final_lex import tokens

# 紀錄變數的globl set
variables = {}

# Evaluate AST Node
def evaluate(node, local_scope=None):
    
    scope = local_scope or {}  # if no local scope, create one

    if type(node) == tuple:  # 還需要繼續 evaluate 下去
        op = node[0]
        if op == '+':
            values = [evaluate(exp, scope) for exp in node[1]]
            result = 0
            for v in values:
                if not type(v) == int:
                    raise TypeError(f"TypeError: Operator '+' expects integers, but got: {values}")
                result += v
            return result
        elif op == '-':
            left = evaluate(node[1], scope)
            right = evaluate(node[2], scope)
            if not (type(left)==int and type(right)==int):  # 用 isinstance 會因為 bool 是 int 的 sub-type，而判定相等
                raise TypeError(f"TypeError: Operator '-' expects integers, but got: {left}, {right}")
            return left - right
        elif op == '*':
            values = [evaluate(exp, scope) for exp in node[1]]
            result = 1
            for v in values:
                if not type(v) == int:
                    raise TypeError(f"TypeError: Operator '*' expects integers, but got: {values}")
                result *= v
            return result
        elif op == '/':
            left = evaluate(node[1], scope)
            right = evaluate(node[2], scope)
            if not (type(left)==int and type(right)==int):
                raise TypeError(f"TypeError: Operator '/' expects integers, but got: {left}, {right}")
            if right == 0:
                raise ZeroDivisionError("ZeroDivisionError: Division by zero")
            return left // right
        elif op == 'mod':
            left = evaluate(node[1], scope)
            right = evaluate(node[2], scope)
            if not (type(left)==int and type(right)==int):
                raise TypeError(f"TypeError: Operator 'mod' expects integers, but got: {left}, {right}")
            return left % right
        elif op == '>':
            left = evaluate(node[1], scope)
            right = evaluate(node[2], scope)
            if not (type(left)==int and type(right)==int):
                raise TypeError(f"TypeError: Operator '>' expects integers, but got: {left}, {right}")
            return left > right
        elif op == '<':
            left = evaluate(node[1], scope)
            right = evaluate(node[2], scope)
            if not (type(left)==int and type(right)==int):
                raise TypeError(f"TypeError: Operator '<' expects integers, but got: {left}, {right}")
            return left < right
        elif op == '=':
            values = [evaluate(exp, scope) for exp in node[1]]
            
            for v in values:
                if not type(v)==int:
                    raise TypeError(f"TypeError: Operator '=' expects integers, but got: {values}")
                if not v==values[0]: return False   
            return True
        elif op == 'AND':
            values = [evaluate(exp, scope) for exp in node[1]]
            if not all(type(v)==bool for v in values):
                raise TypeError(f"TypeError: Operator 'AND' expects booleans, but got: {values}")
            return all(values)
        elif op == 'OR':
            values = [evaluate(exp, scope) for exp in node[1]]
            if not all(type(v)==bool for v in values):
                raise TypeError(f"TypeError: Operator 'OR' expects booleans, but got: {values}")
            return any(values)
        elif op == 'NOT':
            value = evaluate(node[1], scope)
            if not type(value)==bool:
                raise TypeError(f"TypeError: Operator 'NOT' expects a boolean, but got: {value}")
            return not value
        elif op == 'DEFINE':
            # 定義全局變數
            variables[node[1]] = evaluate(node[2], scope)
        elif op == 'FUN':  # 函數定義
            _, params, body = node
            if isinstance(body, tuple) and body[0] == 'NDEF':  # 有巢狀定義
                evaluate(body[1], scope)
                return ('FUN', params, body[2], scope) # 存環境
            else:
                return ('FUN', params, body, scope) # 存環境
        elif op == 'CALL':  # 函數調用
            function = evaluate(node[1], scope)  # node[1] 是 FUNC_expr 或 ID
            args = [evaluate(param, scope) for param in node[2]]

            if type(function) == tuple and function[0] == 'FUN':
                _, params, body, closure_scope = function
                local_scope = {**closure_scope, **dict(zip(params, args))}  # 參數名綁引數值，解包並合併字典，這邊應會導致閉包跟原scope脫鉤，但測資不會重新賦值給變數
                return evaluate(body, local_scope)
            elif isinstance(function, str) and function in variables:  # 已定義的命名函式
                fun_def = variables[function]
                if isinstance(fun_def, tuple) and fun_def[0] == 'FUN':
                    _, params, body, closure_scope = fun_def
                    local_scope = {**closure_scope, **dict(zip(params, args))}
                    return evaluate(body, local_scope)
            raise Exception(f"Invalid function call: {function}")
        elif op == 'IF':
            condition = evaluate(node[1], scope)
            if not type(condition)==bool:
                raise TypeError(f"TypeError: Condition in 'IF' expects a boolean, but got: {condition}")
            return evaluate(node[2] if condition else node[3], scope)
        elif op == 'print-num':
            value = evaluate(node[1], scope)
            if not type(value) == int:
                raise TypeError(f"print-num expects an integer, but got: {value}")
            print(value)
        elif op == 'print-bool':
            value = evaluate(node[1], scope)
            if not type(value)==bool:
                raise TypeError(f"TypeError: print-bool expects a boolean, but got: {value}")
            print('#t' if value else '#f')
        else:
            raise Exception(f"Unsupported operation: {op}")
    elif type(node) == str:  # look up for variable
        if node in scope:
            return scope[node]  # first, look up in local scope
        elif node in variables:
            return variables[node]  # sevond, look up in global scope
        else:
            raise Exception(f"Undefined variable: {node}")
    else:
        return node  # 常數值(常數或是運算結果)直接把值回傳


# --- Grammar ---
def p_program(p):
    '''program : stmt_list'''
    p[0] = p[1]

def p_stmt_list(p):
    '''stmt_list : stmt
                 | stmt stmt_list'''
    p[0] = [p[1]] if len(p) == 2 else [p[1]] + p[2]

def p_stmt(p):
    '''stmt : expr
            | def_stmt
            | print_stmt'''
    p[0] = p[1]

def p_print_stmt(p):
    '''print_stmt : LPAREN PRINT_NUM expr RPAREN
                  | LPAREN PRINT_BOOL expr RPAREN'''
    p[0] = (p[2], p[3])

def p_exp(p):
    '''expr : BOOL_VAL
           | NUMBER
           | ID
           | num_op
           | logical_op
           | func_expr
           | func_call
           | if_expr'''
    p[0] = p[1]

def p_num_op(p):
    '''num_op : LPAREN PLUS expr expr_list RPAREN
              | LPAREN MINUS expr expr RPAREN
              | LPAREN MULTIPLY expr expr_list RPAREN
              | LPAREN DIVIDE expr expr RPAREN
              | LPAREN MODULUS expr expr RPAREN
              | LPAREN GREATER expr expr RPAREN
              | LPAREN SMALLER expr expr RPAREN
              | LPAREN EQUAL expr expr_list RPAREN'''
    if p[2] in ['+', '*', '=']:
        p[0] = (p[2], [p[3]] + (p[4] if isinstance(p[4], list) else [p[4]]))
    else:
        p[0] = (p[2], p[3], p[4])

def p_exp_list(p):
    '''expr_list : expr
                | expr expr_list'''
    p[0] = [p[1]] if len(p) == 2 else [p[1]] + p[2]

def p_logical_op(p):
    '''logical_op : LPAREN AND expr expr_list RPAREN
                  | LPAREN OR expr expr_list RPAREN
                  | LPAREN NOT expr RPAREN'''
    if p[2] == 'and':
        p[0] = ('AND', [p[3]] + p[4])
    if p[2] == 'or':
        p[0] = ('OR', [p[3]] + p[4])
    if p[2] == 'not':
        p[0] = ('NOT', p[3])

def p_def_stmt(p):
    '''def_stmt : LPAREN DEFINE ID expr RPAREN'''
    p[0] = ('DEFINE', p[3], p[4])

# --- function ---
def p_fun_exp(p):
    '''func_expr : LPAREN FUN LPAREN func_params RPAREN func_body RPAREN'''
    p[0] = ('FUN', p[4], p[6])  # 定義函數，包含參數列表和函數本體

def p_fun_ids(p):
    '''func_params : 
               | ID func_params'''
    if len(p) == 1:
        p[0] = []
    else:
        p[0] = [p[1]] + p[2]

def p_fun_body(p):
    '''func_body : expr
                | def_stmt expr'''
    if len(p) == 2:
        p[0] = p[1]
    else:
        p[0] = ('NDEF', p[1], p[2])  # Nested Define

def p_fun_call(p):
    '''func_call : LPAREN func_expr param_list RPAREN
                | LPAREN ID param_list RPAREN'''
    if p[2][0] == 'FUN':
        p[0] = ('CALL', p[2], p[3])  # 匿名函數
    else:
        p[0] = ('CALL', p[2], p[3])  # 命名函數

def p_param_list(p):
    '''param_list : 
                  | param param_list'''
    if len(p) == 1:
        p[0] = []
    else:
        p[0] = [p[1]] + p[2]

def p_param(p):
    '''param : expr'''
    p[0] = p[1]
# --- function ---

def p_if_exp(p):
    '''if_expr : LPAREN IF expr expr expr RPAREN'''
    p[0] = ('IF', p[3], p[4], p[5])
# --- Grammar ---



# error handling
def p_error(p):
    print(f"Syntax Error: {p}")
    print("-" * 40)

# build parser
parser = yacc.yacc()

'''
# debug mode
if __name__ == "__main__":
    data = """
    (define dist-square
    (fun (x y)
    (define square (fun (x) (* x x)))
    (+ (square x) (square y))))

    (print-num (dist-square 3 4))
    """
    result = parser.parse(data,debug=True)
    print(result)
'''