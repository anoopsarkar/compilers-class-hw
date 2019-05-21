// g++ -std=c++17 -o symtbl_test symtbl_test.c

#include <utility>      // std::pair, std::make_pair
#include <string>       // std::string
#include <iostream>     // std::cout
#include <map>          // std::map
#include <list>         // std::list

using namespace std;
typedef pair<int, int> descriptor;
typedef map<string, descriptor* > symbol_table;
typedef list<symbol_table > symbol_table_list;
symbol_table_list symtbl;
descriptor* access_symtbl(string ident) {
    for (auto i : symtbl) {
        auto find_ident = i.find(ident);
        if (find_ident != i.end()) {
            return find_ident->second;
        }
    }
    return NULL;
}

int main()
{
    symbol_table outer;
    outer["x"] = new descriptor(1,5);
    outer["y"] = new descriptor(1,7);
    symtbl.push_front(outer);
    descriptor* d = access_symtbl("y");
    if (d != NULL) {
        cout << d->first << '\t' << d->second << endl;
    }
}
