import ply.lex as lex

# 定義 token
tokens = [
    'NUMBER',      # 數字
    'ID',          # 標識符
    'BOOL_VAL',    # 布林值 #t 和 #f
    'LPAREN',      # 左括號
    'RPAREN',      # 右括號

    # Numerical Operators 
    'PLUS',
    'MINUS',
    'MULTIPLY',
    'DIVIDE',
    'MODULUS',
    'GREATER',
    'SMALLER',
    'EQUAL',

    'DEFINE', 
    'PRINT_NUM', 
    'PRINT_BOOL', 
     
    'AND', 
    'OR', 
    'NOT',

    'IF',

    'FUN'

]  

# 定義正則表達式規則
t_LPAREN    = r'\('
t_RPAREN    = r'\)'
t_PLUS      = r'\+'
t_MINUS     = r'-'
t_MULTIPLY  = r'\*'
t_DIVIDE    = r'/'
t_MODULUS   = r'mod'
t_GREATER   = r'>'
t_SMALLER   = r'<'
t_EQUAL     = r'='

# 定義布林值
def t_BOOL_VAL(t):
    r'\#t|\#f'
    t.value = True if t.value == '#t' else False
    return t

# 定義數字 (NUMBER)
def t_NUMBER(t):
    r'0|(-?[1-9]\d*)'
    t.value = int(t.value)
    return t

# 定義標識符 (ID)
def t_ID(t):
    r'[a-zA-Z]([a-zA-Z0-9\-])*'
    t.type = {
        'define': 'DEFINE',
        'print-num': 'PRINT_NUM',
        'print-bool': 'PRINT_BOOL',
        'and': 'AND',
        'or': 'OR',
        'not': 'NOT',
        'if': 'IF',
        'mod': 'MODULUS',
        'fun': 'FUN'
    }.get(t.value, 'ID')  # 檢查是否為關鍵字，否則類型為 ID
    return t

# 忽略分隔符
t_ignore = ' \t\n\r'

# 錯誤處理
def t_error(t):
    print(f"Syntax error: {t.value[0]}")
    t.lexer.skip(1)

# 建立詞法分析器
lexer = lex.lex()

# debug
'''
if __name__ == "__main__":
    data = """
    (define x 10)
    (define y (if (> x 5) (+ x 5) (- x 5)))
    (print-num y)
    """
    lexer.input(data)
    while token := lexer.token():
        print(token)
'''