// ParserTest

// Productions
// 1 program → stmts
// 2 stmts → stmt stmts
// 3 stmts → λ
// 4 stmt → primary
// 5 stmt → STRLIT
// 6 stmt → λ
// 7 primary → ID primary_tail
// 8 primary_tail → DOT ID primary_tail
// 9 primary_tail → LBR stmt RBR primary_tail
// 10 primary_tail → λ

#include <iostream>

using namespace std;

bool isLegal = true;
string output = "";

void program();
void stmts();
void stmt();
void primary();
void primary_tail();
void Terminal(string);
void ERROR();

void program()
{
    // cout << "program\n";
    if(!isLegal) return;

    stmts();
}

void stmts()
{
    // cout << "stmts\n";
    if(!isLegal) return;
    char pk = cin.peek();
    
    if(pk == ' ' || pk == '\n')
    {
        cin.read(&pk, 1);
        pk = cin.peek();
    }

    if(pk == '\"' || 
       (('A' <= pk && pk <= 'Z') ||
        ('a' <= pk && pk <= 'z') ||
        pk == '_' ))
    {
        stmt();
        stmts();
    }
    else if(pk == EOF)
    {
        return;
    }
    else
    {
        ERROR();
    }
    
}

void stmt()
{
    // cout << "stmt\n";
    if(!isLegal) return;

    char pk = cin.peek();

    if(pk == ' ' || pk == '\n')
    {
        cin.read(&pk, 1);
        pk = cin.peek();
    }

    if(pk == '\"')
    {
        Terminal("STRLIT");
    }
    else if ( ('A' <= pk && pk <= 'Z') ||
              ('a' <= pk && pk <= 'z') ||
              pk == '_' )
    {
        primary();
    }
}

void primary()
{
    // cout << "primary\n";
    if(!isLegal) return;

    Terminal("ID");
    
    char pk = cin.peek();
    if(pk == ' ' || pk == '\n')
    {
        cin.read(&pk, 1);
        pk = cin.peek();
    }
    
    primary_tail();
}

void primary_tail()
{
    // cout << "primary_tail\n";
    if(!isLegal) return;

    char pk = cin.peek();

    if(pk == ' ' || pk == '\n')
    {
        cin.read(&pk, 1);
        pk = cin.peek();
    }

    if(pk == '.')
    {
        Terminal("DOT");
        Terminal("ID");
        primary_tail();
    }
    else if(pk == '(')
    {
        Terminal("LBR");
        stmt();
        Terminal("RBR");
        primary_tail();
    }
}

void Terminal(string type)
{
    // cout << type << '\n';
    if(!isLegal) return;
    char c;
    string token = "";
    string tmp = "";

    // delete it
    c = cin.peek();
    if(c == ' ' || c == '\n')
    {
        cin.read(&c, 1);
    }

    if(type == "ID")
    {
        c =  cin.peek();

        if ( ('A' <= c && c <= 'Z') ||
             ('a' <= c && c <= 'z') ||
             c == '_' )
        {
            cin.read(&c, 1);
            token += c;
        }
        else
        {
            ERROR();
            return;
        }

        while(true)
        {
            c =  cin.peek();
            if ( !(('A' <= c && c <= 'Z') ||
                 ('a' <= c && c <= 'z') ||
                 c == '_' ||
                 ('0' <= c && c <= '9')))
            {
                break;
            }
            cin.read(&c, 1);
            token+=c;
        }
        
        output.append("ID ").append(token).append("\n");
    }
    else if(type == "STRLIT")
    {
        cin.read(&c, 1);
        if(c != '\"')
        {
            ERROR();
            return;
        }
        token = "\"";

        do
        {
            cin.read(&c, 1);
            if(c == '\n')
            {
                ERROR();
                return;
            }
            token += c;
        }
        while(c != '\"');        

        output.append("STRLIT ").append(token).append("\n");
    }
    else if(type == "LBR")
    {
        cin.read(&c, 1);
        if(c != '(')
        {
            ERROR();
        }
        output.append("LBR (\n");
    }
    else if(type == "RBR")
    {
        cin.read(&c, 1);
        if(c != ')')
        {
            ERROR();
        }
        output.append("RBR )\n");
    }
    else if(type == "DOT")
    {
        cin.read(&c, 1);
        if(c != '.')
        {
            ERROR();
        }
        output.append("DOT .\n");
    }
}

void ERROR()
{   
    if(!isLegal) return;

    isLegal = false;
    // cout << (char)cin.peek() <<'\n';
    cout << "invalid input\n";
}

int main()
{
    program();
    if(isLegal)
    {
        cout << output;
    }
}