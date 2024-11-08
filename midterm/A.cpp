// ParserTest

// 1. program → stmt
// 2. stmt → PHONENUM
// 3. stmt → mail
// 4. stmt → uri
// 5. mail→ PATH AT MAILDOMAIN DOT DOMAIN
// 6. uri → SCHEME COLON SLASH SLASH PATH DOT DOMAIN
// 7. uri→ SCHEME COLON mail
// 8. uri→SCHEME COLON PHONENUM

#include <iostream>

using namespace std;

bool isValid = true;
string text = "";
int len = 0;
string output = "";

int head = 0;
int tail = 0;

void program();
void stmt();
void mail();
void uri();

string PHONE();
string PATH();
string MAILDOMAIN();
string DOMAIN();
string SCHEME();
string COLON();
string AT();
string DOT();
string SLASH();

void ERROR();

void program()
{
    // cout << "program\n";
    if(!isValid) return;
    stmt();
}

void stmt()
{
    if(!isValid) return;

    string next;
    
    next = PHONE();
    if(next != "")
    {
        output.append(next).append(" PHONENUM\n");
        return;
    }

    next = SCHEME();
    if(next != "")
    {
        output.append(next).append(" SCHEME\n");
        uri();
        return;
    }
    
    next = PATH();
    if(next != "")
    {
        output.append(next).append(" PATH\n");
        mail();
        return;
    }

    ERROR();
}

void mail()
{
    if(!isValid) return;

    // PATH AT MAILDOMAIN DOT DOMAIN
    string next = "";

    next = AT();
    if (next != "")
    {
        output.append(next).append(" AT\n");
    }
    else
    {
        ERROR();
        return;
    }

    next = MAILDOMAIN();
    if (next != "")
    {
        output.append(next).append(" MAILDOMAIN\n");
    }
    else
    {
        ERROR();
        return;
    }

    next = DOT();
    if (next != "")
    {
        output.append(next).append(" DOT\n");
    }
    else
    {
        ERROR();
        return;
    }

    next = DOMAIN();
    if (next != "")
    {
        output.append(next).append(" DOMAIN\n");
    }
    else
    {
        ERROR();
        return;
    }
}

// 6. uri → SCHEME COLON SLASH SLASH PATH DOT DOMAIN
// 7. uri→ SCHEME COLON mail
// 8. uri→SCHEME COLON PHONENUM
void uri()
{
    if(!isValid) return;
    string next = "";

    next = COLON();
    if (next != "")
    {
        output.append(next).append(" COLON\n");
    }
    else
    {
        ERROR();
        return;
    }

    next = SLASH();
    if (next != "")
    {
        output.append(next).append(" SLASH\n");
        
        next = SLASH();
        if (next != "")
        {
            output.append(next).append(" SLASH\n");
        }
        else
        {
            ERROR();
            return;
        }

        next = PATH();
        if (next != "")
        {
            output.append(next).append(" PATH\n");
        }
        else
        {
            ERROR();
            return;
        }

        next = DOT();
        if (next != "")
        {
            output.append(next).append(" DOT\n");
        }
        else
        {
            ERROR();
            return;
        }

        next = DOMAIN();
        if (next != "")
        {
            output.append(next).append(" DOMAIN\n");
        }
        else
        {
            ERROR();
            return;
        }

        return;
    }

    next = PATH();
    if (next != "")
    {
        output.append(next).append(" PATH\n");
        mail();
        return;
    }

    next = PHONE();
    if (next != "")
    {
        output.append(next).append(" PHONENUM\n");
        return;
    }

    ERROR();
    return;
}


string PHONE()
{
    if(!isValid) return "";

    int h = head;
    string tmp = "09";

    if(!(text[h] == '0' && text[h+1] == '9'))
        return "";
    h += 2;
    for (int i=0; i<8; i++)
    {
        if(!(text[h+i] >= '0' && text[h+i] <= '9'))
            return "";
        tmp += text[h+i];
    }

    head += 10;
    return tmp;
}

string PATH()
{
    if(!isValid) return "";

    int h = head;
    int c = text[h];
    string tmp = "";
    if (!((c >= 'a' && c <= 'z') ||
          (c >= 'A' && c <= 'Z') ||
          (c >= '0' && c <= '9')))
        return "";
    tmp += c;
    h++;   
    c = text[h];
    while (((c >= 'a' && c <= 'z') ||
          (c >= 'A' && c <= 'Z') ||
          (c >= '0' && c <= '9')))
    {
        tmp += c;
        c = text[++h];
    }
    head = h;
    return tmp;
}

string MAILDOMAIN()
{
    if(!isValid) return "";

    if(head > len - 5) return "";
    if(text.substr(head, 5) == "gmail"){ head += 5; return "gmail";}
    if(text.substr(head, 5) == "yahoo"){ head += 5;  return "yahoo";}

    if(head > len - 6) return "";
    if(text.substr(head, 6) == "iCloud"){ head += 6;  return "iCloud";}
    if(text.substr(head, 6) == "outlook"){ head += 6;  return "outlook";}
    return "";
}


string DOMAIN()
{
    if(!isValid) return "";

    if(head > len - 3) return "";
    if(text.substr(head, 3) == "org"){ head += 3; return "org";}
    if(text.substr(head, 3) == "com"){ head += 3; return "com";}
    return "";
}

string SCHEME()
{
    if(!isValid) return "";

    if(head > len - 3) return "";
    if(text.substr(head, 3) == "tel"){ head += 3; return "tel";}
    if(head > len - 5) return "";
    if(text.substr(head, 5) == "https"){ head += 5; return "https";}
    if(head > len - 6) return "";
    if(text.substr(head, 6) == "mailto"){ head += 6; return "mailto";}

    return "";
}

string COLON()
{
    if(!isValid) return "";

    if(text[head] == ':')
    {
        head++;
        return ":";
    }
    return "";
}

string AT()
{
    if(!isValid) return "";

    if(text[head] == '@')
    {
        head++;
        return "@";
    }
    return "";
}

string DOT()
{
    if(!isValid) return "";

    if(text[head] == '.')
    {
        head++;
        return ".";
    }
    return "";
}

string SLASH()
{
    if(!isValid) return "";

    if(text[head] == '/')
    {
        head++;
        return "/";
    }
    return "";
}

void ERROR()
{   
    if(!isValid) return;

    // cout << "!!!: "<< text[head]<<"\n";
    isValid = false;
    cout << "Invalid input\n";
}

int main()
{
    cin >> text;
    len = text.end() - text.begin();
    program();
    if(isValid)
    {
        cout << output;
    }
}