#include <iostream>

using namespace std;

string symbols = "+-*/=(){}<>;";
string ans = "";
char pk;

//Terminal Regular Expression
// NUM (0|[1-9][0-9]*)
// IDENTIFIER [A-Za-z][A-Za-z0-9]*
// SYMBOL [\+\-\*\/\=\(\)\{\}\<\>\;]
// KEYWORD (if|while)

void NUM();
void IDandKEY();
void SYMBOL();
void INVALID();
bool isSymbol();

void NUM()
{
    ans.append("NUM \"");

    pk = cin.peek();
    if (pk == '0')
    {
        ans += pk;
        cin.read(&pk, 1);
    }
    else if (pk > '0' && pk <= '9')
    {
        while (true)
        {
            pk = cin.peek();
            if (!(pk >= '0' && pk <= '9')) break;

            ans += pk;
            cin.read(&pk, 1);
        }
    }

    ans.append("\"\n");
}

void IDandKEY()
{
    int iswhile = 0;
    int isIf = 0;
    string tmp = "";

    cin.read(&pk, 1);
    if (pk == 'w')
    {
        iswhile = 1;
    }
    else if (pk == 'i')
    {
        isIf = 1;
    }
    tmp += pk;
    while (true)
    {
        pk = cin.peek();
        if ((pk >= 'A' && pk <= 'Z') ||
            (pk >= 'a' && pk <= 'z') ||
            (pk >= '0' && pk <= '9') )
        {
            // cout << "pk: " << pk << endl;
            // cout << "isW: " << iswhile << endl;
            if (pk == 'h' && iswhile == 1)
            {
                iswhile = 2;
            }
            else if (pk == 'i' && iswhile == 2)
            {
                iswhile = 3;
            }
            else if (pk == 'l' && iswhile == 3)
            {
                iswhile = 4;
            }
            else if (pk == 'e' && iswhile == 4)
            {
                iswhile = 5;
            }
            else if (pk == 'f' && isIf == 1)
            {
                isIf = 2;
            }
            else
            {
                iswhile = 0;
                isIf = 0;
            }
            // cout << "isW " << iswhile << endl;
            // cout << "isI " << isIf << endl;
            
            tmp += pk;
            cin.read(&pk, 1);
        }
        else
        {
            break;
        }

    }

    if (iswhile == 5)
    {
        ans.append("KEYWORD \"while\"\n");
    }
    else if (isIf == 2)
    {
        ans.append("KEYWORD \"if\"\n");
    }
    else
    {
        ans.append("IDENTIFIER \"").append(tmp).append("\"\n");   
    }
}

void SYMBOL()
{
    ans.append("SYMBOL \"");
    cin.read(&pk, 1);
    ans += pk;
    ans.append("\"\n");
}

void INVALID()
{
    ans.append("Invalid\n");
    cin.read(&pk, 1);
}

bool isSymbol(char c)
{
    for(int i=0; i<12; i++)
    {
        if(c == symbols[i])
            return true;
    }
    return false;
}

int main()
{
    while(true)
    {
        pk = cin.peek();

        if(pk == EOF) break;

        if(pk == ' ' || pk == '\n' || pk == '\r')
        {
            cin.read(&pk, 1);
            continue;
        }

        if (pk >= '0' && pk <= '9')
        {
            NUM();
        }    
        else if ((pk >= 'A' && pk <= 'Z') ||
                 (pk >= 'a' && pk <= 'z' ))
        {
            IDandKEY();
        }
        else if (isSymbol(pk))
        {
            SYMBOL();
        }
        else
        {
            INVALID();
        }

    }

    cout << ans;
}