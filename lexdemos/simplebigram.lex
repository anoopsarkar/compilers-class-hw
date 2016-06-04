
%{

#include <iostream>
#include <sstream>
#include <utility>
#include <string>
#include <map>
#include <iterator>
#include <vector>
#include <algorithm>
#include <cstdlib>

using namespace std;

typedef pair<string, string> bigram_type;
typedef map<bigram_type, int>::iterator dict_iter;

map<bigram_type, int> dict;

void
addtodict(char *yytext) {
  string s(yytext);
  istringstream sin(s);
  vector<string> tokens;
  copy(istream_iterator<string>(sin), istream_iterator<string>(), back_inserter(tokens));
  bigram_type key(tokens[0], tokens[1]);
  dict_iter find_bigram; 
  if ((find_bigram = dict.find(key)) != dict.end()) {
    dict[key] = dict[key] + 1;
  } else {
    dict[key] = 1;
  }
}

%}

ws [ \t\n]*
notws [^ \t\n]+

%%

^{notws}{ws}{notws}{ws}		{ addtodict(yytext); }
{ws}{notws}{ws}{notws}{ws}	{ addtodict(yytext); }
.|\n                        /* do nothing */

%%

int main () {
  yylex();
  for (dict_iter i = dict.begin(); i != dict.end(); i++) {
    cout << (i->first).first << " " << (i->first).second << " " << i->second << endl;
  }
  exit(EXIT_SUCCESS);
}

