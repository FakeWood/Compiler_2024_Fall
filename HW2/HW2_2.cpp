#include <iostream>
#include <map>
#include <set>

using namespace std;

map< char, set<string> > grammars;
map< char, set<char> > FIRSTs;

// Find First Set of Symbol symbol
void First(char symbol)
{
    if (!FIRSTs[symbol].empty()) return;
    set<char> first = {};
    set<string> RHS = grammars[symbol];

    for (string grammar : RHS)
    {
        bool isPhi = true;
        for (int i = 0; i < grammar.length(); i++)
        {
            if (isPhi == false)
            {
                break;
            }

            char sym = grammar[i];
            
            // terminal
            if ( ('a' <= sym &&  sym <= 'z') || sym == '$' || sym == ';')
            {
                first.insert(sym);
                break;
            }
            
            // non-terminal
            First(sym);
            
            if (FIRSTs[sym].count(';') == 0)
            {
                isPhi = false;
            }
            
            for (char c : FIRSTs[sym])
            {
                if (c == ';' && i != grammar.length() - 1) continue;

                first.insert(c);
            }

        }
    }

    FIRSTs[symbol] = first;
    return;
}

int main()
{
    // input
    while(true)
    {
        string line = "";
        getline(cin, line);
        if (line == "END_OF_GRAMMAR") break;

        // remove the space ending
        if (line[line.length()-1] == ' ') line = line.substr(0, line.length()-1);

        char LHS = line[0];
        set<string> RHS;
        int head = 2; // = 2 cuz LHS and space
        int tail = 2;
        while (true)
        {
            if (tail == line.length())
            {
                RHS.insert(line.substr(head, tail - head));
                grammars[LHS] = RHS;
                break;
            }

            if (line[tail] == '|')
            {
                RHS.insert(line.substr(head, tail - head));
                head = tail + 1;
            }
            tail++;
        }
        
    }
    
    for (pair<char, set<string> > p : grammars)
    {
        First(p.first);
    }

    // cout << "Grammar: \n";
    // for (auto s : grammars)
    // {    
    //     cout << s.first << ": ";
    //     for ( auto str : s.second)
    //     {
    //         cout << str << " ";
    //     }
    //     cout << "\n";
    // }
    
    // cout << "-----------\nFIRST: \n";

    for (auto f : FIRSTs)
    {
        cout << f.first << " ";
        for (char c : f.second)
        {
            cout << c;
        }
        cout << " \n";
    }
    cout << "END_OF_FIRST \n";
}