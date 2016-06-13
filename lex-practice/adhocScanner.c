
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

 /* Each different token type has its own unique code */    
#define T_SEMICOLON   ';'  // use ASCII values for single char tokens  
#define T_LPAREN      '('   
#define T_RPAREN      ')'  
#define T_EQ	      '='  
#define T_LT          '<'  
#define T_GT          '>'  
#define T_DIVIDE      '/'     
// ...    

#define T_WHILE       257  // reserved words   
#define T_IF          258  
#define T_RETURN      259  
// ...    

#define T_IDENTIFIER  268  // identifiers, constants, etc.  
#define T_INTEGER     269  
#define T_DOUBLE      270  
#define T_STRING      271    
#define T_END         349  // code used when at end of file   
#define T_UNKNOWN     350  // token was unrecognized by scanner      

struct token_t {    
  int type;                // one of the token codes from above   
  union {      
    char stringValue[256]; // holds lexeme value if string/identifier      
    int intValue;          // holds lexeme value if integer      
    double doubleValue;    // holds lexeme value if double     
  } val;  
};        

int
lookup_reserved (const char *kw)  
{    
  if (strcmp("while", kw) == 0) return T_WHILE;
  if (strcmp("if", kw) == 0) return T_IF;
  if (strcmp("return", kw) == 0) return T_RETURN;
  // ...
  return -1;
}    

static int 
ScanOneToken (FILE *fp, struct token_t *token)  
{    
  int i, ch, nextch, prevch;
  ch = getc(fp);       // read next char from input stream    
  while (isspace(ch))  // if necessary, keep reading til non-space char      
    ch = getc(fp);     // (discard any white space)       
  switch(ch) {      
  case '/':            // could either begin comment or T_DIVIDE op     
    nextch = getc(fp);        
    if (nextch == '/' || nextch == '*') {
      ; // here you would skip over the comment     
    } else {
      ungetc(nextch, fp); // fall-through to single-char token case
      token->type = ch;
	  return ch;
	}
  case ';': case '(': case ')': case ',': case '=': case '<': case '>':  // ... and other single char tokens         
    token->type = ch;              // ASCII value is used as token type        
    return ch;                     // ASCII value used as token type           
  case '\"':
    token->type = T_STRING;
    prevch = ch;
    ch = getc(fp);
    for (i = 0; (prevch != '\\') && (ch != '\"'); i++) {
      token->val.stringValue[i] = ch;
      prevch = ch;
      ch = getc(fp);
    }
    token->val.stringValue[i] = '\0';
    return token->type;
  case 'A': case 'B': case 'C': case 'D': case 'E': case 'F': case 'G':
  case 'H': case 'I': case 'J': case 'K': case 'L': case 'M': case 'N':
  case 'O': case 'P': case 'Q': case 'R': case 'S': case 'T': case 'U':
  case 'V': case 'W': case 'X': case 'Y': case 'Z': 
    token->val.stringValue[0] = ch;         
    for (i = 1; isupper(ch = getc(fp)); i++) // gather uppercase      
      token->val.stringValue[i] = ch;     
    ungetc(ch, fp);         
    token->val.stringValue[i] = '\0';  // lookup reserved word     
    token->type = lookup_reserved(token->val.stringValue);     
    return token->type;           
  case 'a': case 'b': case 'c': case 'd': case 'e': case 'f': case 'g':
  case 'h': case 'i': case 'j': case 'k': case 'l': case 'm': case 'n':
  case 'o': case 'p': case 'q': case 'r': case 's': case 't': case 'u':
  case 'v': case 'w': case 'x': case 'y': case 'z': 
    token->val.stringValue[0] = ch;        
    for (i = 1; islower(ch = getc(fp)); i++)           
      token->val.stringValue[i] = ch; // gather lowercase     
    ungetc(ch, fp);      
    token->val.stringValue[i] = '\0';     
	int lookup_type = lookup_reserved(token->val.stringValue);     
	if (lookup_type != -1) {
    	token->type = lookup_type;
		return lookup_type;           
	}
    token->type = T_IDENTIFIER;     
    return T_IDENTIFIER;        
  case '0': case '1': case '2': case '3': case '4': 
  case '5': case '6': case '7': case '8': case '9':
    token->type = T_INTEGER;        
    token->val.intValue = ch - '0';            
    while (isdigit(ch = getc(fp)))  // convert digit char to number          
      token->val.intValue = token->val.intValue * 10 + ch - '0';     
    ungetc(ch, fp);       
    return T_INTEGER;        
  case EOF:     
    return T_END; 
 default:   // anything else is not recognized     
   token->val.intValue = ch;     
   token->type = T_UNKNOWN;     
   return T_UNKNOWN;   
  }  
}  
   
int
main (int argc, char *argv[])  
{    
  struct token_t token;      
  while (ScanOneToken(stdin, &token) != T_END) {
    // here is where you would process each token
    // printf("type:%d", token.type);
    switch(token.type) {
    case T_WHILE: printf("%s","T_WHILE"); break; 
	case T_IF: printf("%s","T_IF");  break;
    case T_RETURN: printf("%s","T_RETURN"); break; 
	case T_IDENTIFIER: printf("%s","T_IDENTIFIER"); printf(" value:\'%s\'", token.val.stringValue); break;
    case T_STRING: printf("T_STRING value:\"%s\"", token.val.stringValue); break;
    case T_INTEGER: printf("T_INTEGER value:%d", token.val.intValue); break;
    case T_DOUBLE: printf("T_DOUBLE value:%lf", token.val.doubleValue); break;
	default:
      if (token.type < 127) {
        switch(token.type) {
        case T_LPAREN: printf("T_LPAREN value:\'%c\'", token.type); break;
        case T_RPAREN: printf("T_RPAREN value:\'%c\'", token.type); break;
        case T_EQ: printf("T_EQ value:\'%c\'", token.type); break;
        case T_LT: printf("T_LT value:\'%c\'", token.type); break;
        case T_GT: printf("T_GT value:\'%c\'", token.type); break;
        case T_DIVIDE: printf("T_DIVIDE value:\'%c\'", token.type); break;
        default: printf("T_CHAR value:\'%c\'", token.type);
        }
      } else {
        printf("T_UNKNOWN value:%c", token.val.intValue);
      }
    }
    printf("\n");
  }
  return 0;  
}    

