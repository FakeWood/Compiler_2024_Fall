import os
import ply.yacc as yacc
from final_lex import tokens
from final_yacc import parser, evaluate

FOLDER = "./final_project/public_test_data"

def process_lsp_files(folder_path):
    # find folder
    if not os.path.exists(folder_path):
        print(f"ERROR: Fodler \"{folder_path}\" does not exist. ")
        return
    
    # find all .lsp file
    files = [f for f in os.listdir(folder_path) if f.endswith('.lsp')]
    if not files:
        print(f"ERROR: No .lsp file in folder \"{folder_path}\"")
        return
    
    print("-" * 40)
    for file_name in files:
        file_path = os.path.join(folder_path, file_name)
        print(f"File: {file_name}\n")
        
        try:
            # read file
            with open(file_path, 'r', encoding='utf-8') as file:
                data = file.read()
            # parese data
            results = parser.parse(data)
            if results is None:
                # print(f"ERROR: ", end='')
                continue
            
            # evaluate the parsing result
            for result in results:
                evaluate(result)
            
        except Exception as e:
            print(f"{e}")
        print("-" * 40)

if __name__ == "__main__":
    process_lsp_files(FOLDER)
