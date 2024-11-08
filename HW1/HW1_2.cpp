#include <iostream>

using namespace std;

string ans = "";
char pk;

//Terminal Regular Expression
// NUM ( [1-9][0-9]* ) | 0
// PLUS \+
// MINUS \-
// MUL \*
// DIV \/
// LPR \(
// RPR \)

void NUM();
void PLUS();
void MINUS();
void MUL();
void DIV();
void LPR();
void RPR();

void NUM()
{
    ans.append("NUM ");

    while (true)
    {
        pk = cin.peek();
        if (!(pk >= '0' && pk <= '9')) break;

        ans += pk;
        cin.read(&pk, 1);
    }
    ans+='\n';
    
}

void PLUS()
{
    ans.append("PLUS\n");
    cin.read(&pk, 1);
}

void MINUS()
{
    ans.append("MINUS\n");
    cin.read(&pk, 1);
}

void MUL()
{
    ans.append("MUL\n");
    cin.read(&pk, 1);
}

void DIV()
{
    ans.append("DIV\n");
    cin.read(&pk, 1);
}

void LPR()
{
    ans.append("LPR\n");
    cin.read(&pk, 1);
}

void RPR()
{
    ans.append("RPR\n");
    cin.read(&pk, 1);
}

int main()
{
    while(true)
    {
        pk = cin.peek();

        if(pk == EOF) break;

        if(pk == ' ' || pk == '\n')
        {
            cin.read(&pk, 1);
            continue;
        }

        switch (pk)
        {
        case '+':
            PLUS();
            break;
        case '-':
            MINUS();
            break;
        case '*':
            MUL();
            break;
        case '/':
            DIV();
            break;
        case '(':
            LPR();
            break;
        case ')':
            RPR();
            break;     
        default:
            NUM();
            break;
        }
    }

    cout << ans;
}