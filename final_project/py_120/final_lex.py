import ply.lex as lex

# define token
tokens = [
    'NUMBER',  
    'ID',      
    'BOOL_VAL',
    'LPAREN',  
    'RPAREN',  

    # numerical operators 
    'PLUS',
    'MINUS',
    'MULTIPLY',
    'DIVIDE',
    'MODULUS',

    # logical operation
    'GREATER',
    'SMALLER',
    'EQUAL',
    'AND', 
    'OR', 
    'NOT',

    'DEFINE', 
    'PRINT_NUM', 
    'PRINT_BOOL', 
     
    'IF',

    'FUN'

]  

# match RE to token
t_LPAREN    = r'\('
t_RPAREN    = r'\)'
t_PLUS      = r'\+'
t_MINUS     = r'-'
t_MULTIPLY  = r'\*'
t_DIVIDE    = r'/'
t_GREATER   = r'>'
t_SMALLER   = r'<'
t_EQUAL     = r'='

def t_BOOL_VAL(t):
    r'\#t|\#f'
    t.value = True if t.value == '#t' else False
    return t

def t_NUMBER(t):
    r'0|(-?[1-9]\d*)'
    t.value = int(t.value)
    return t

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
    }.get(t.value, 'ID')  # check if is keyword
    return t

# 忽略分隔符號
t_ignore = ' \t\n\r'

# error handling
def t_error(t):
    print(f"Unrecognize symbol: {t.value[0]}")
    t.lexer.skip(1)

# build lexer
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