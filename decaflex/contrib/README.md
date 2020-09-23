# Contribution
Here are several contributions that students have made towards the project that helps streamline parts of the process.

## Reference
Attempt | description | args | output |
--- | --- | --- | --- 
build.sh | Builds the project and runs against python tests | 0 | None |
evaluate.sh | Compares all the project's output files against the given references to find any failing tests, and where the difference occurs| 0 | None if all outputs are correct, file name and position of difference if failure occurred |
result.sh | Provides outputs for user to compare their output against the reference output, as well as the used test case | 1..* (file name without extension) | Provides the project's original test case, reference output, and the project's output |

## Usage
Here are several use-case examples of the scripts:

`Note: These examples assume you are executing the scripts from the project's root directory`

### Example 1

Input
```
./contrib/build.sh
```
Output
```
make: `decaflex' is up to date.
running on dev files
Warning: output/dev already exists. Existing files will be over-written.
running on test files
Warning: output/test already exists. Existing files will be over-written.
/Users/jkim/Documents/SFU/2020/CMPT379/cmpt379-1207-junhok/decaflex/output.zip created
Correct(dev): 57 / 59
Score(dev): 57.00
Total Score: 57.00
```

### Example 2

Input
```
./contrib/evaluate.sh
```
Output
```
stringescapes-9
T_EXTERN extern						      |	T_ID extern
T_STRINGTYPE string					      |	T_ID string
T_VOID void						      |	T_ID void
T_SEMICOLON ;						      <
T_WHITESPACE 

					      <
T_PACKAGE package					      <
T_WHITESPACE  						      <
T_ID Test						      <
T_WHITESPACE  						      <
T_LCB {							      <
T_WHITESPACE 
						      <
T_FUNC func						      <
T_WHITESPACE  						      <
T_ID main						      <
T_LPAREN (						      <
T_RPAREN )						      <
T_WHITESPACE  						      <
T_INTTYPE int						      <
T_WHITESPACE  						      <
T_LCB {							      <
T_WHITESPACE 
						      <
T_ID print_string					      <
T_LPAREN (						      <
T_STRINGCONSTANT "\""					      <
T_RPAREN )						      <
T_SEMICOLON ;						      <
T_WHITESPACE 
						      <
T_RCB }							      <
T_WHITESPACE 
						      <
T_RCB }							      <
T_WHITESPACE 
						      <
```

### Example 3

General Input
```
./contrib/result.sh {filename1} {filenam2}..
```
Specific Input
```
./contrib/result.sh charvals-5
```
Output
```
---- Original ----
extern func print_int(int) void;
package Test {
	func main() int
	{
		print_int('7');
	}
}
---- Expected ----
T_EXTERN extern
T_WHITESPACE  
T_FUNC func
T_WHITESPACE  
T_ID print_int
T_LPAREN (
T_INTTYPE int
T_RPAREN )
T_WHITESPACE  
T_VOID void
T_SEMICOLON ;
T_WHITESPACE \n
T_PACKAGE package
T_WHITESPACE  
T_ID Test
T_WHITESPACE  
T_LCB {
T_WHITESPACE \n	
T_FUNC func
T_WHITESPACE  
T_ID main
T_LPAREN (
T_RPAREN )
T_WHITESPACE  
T_INTTYPE int
T_WHITESPACE \n	
T_LCB {
T_WHITESPACE \n		
T_ID print_int
T_LPAREN (
T_CHARCONSTANT '7'
T_RPAREN )
T_SEMICOLON ;
T_WHITESPACE \n	
T_RCB }
T_WHITESPACE \n
T_RCB }
T_WHITESPACE \n
---- Actual ----
T_EXTERN extern
T_WHITESPACE  
T_FUNC func
T_WHITESPACE  
T_ID print_int
T_LPAREN (
T_INTTYPE int
T_RPAREN )
T_WHITESPACE  
T_VOID void
T_SEMICOLON ;
T_WHITESPACE \n
T_PACKAGE package
T_WHITESPACE  
T_ID Test
T_WHITESPACE  
T_LCB {
T_WHITESPACE \n	
T_FUNC func
T_WHITESPACE  
T_ID main
T_LPAREN (
T_RPAREN )
T_WHITESPACE  
T_INTTYPE int
T_WHITESPACE \n	
T_LCB {
T_WHITESPACE \n		
T_ID print_int
T_LPAREN (
T_CHARCONSTANT '7'
T_RPAREN )
T_SEMICOLON ;
T_WHITESPACE \n	
T_RCB }
T_WHITESPACE \n
T_RCB }
T_WHITESPACE \n
```

Be cautious that you do not input file names that don't exist inside references/dev. If so, the script will fail.

## Example 4
Piping evaluate and result together to show the result of all files that aren't identical. This way you don't need to manually input every single file name into result.sh.

Input
```
./contrib/evaluate.sh | xargs ./contrib/result.sh
```
Output
```
---- Original ----
extern func print_string(string) void;

package Test {
	func main() int {
		print_string("\"");
	}
}
---- Expected ----
T_EXTERN extern
T_WHITESPACE  
T_FUNC func
T_WHITESPACE  
T_ID print_string
T_LPAREN (
T_STRINGTYPE string
T_RPAREN )
T_WHITESPACE  
T_VOID void
T_SEMICOLON ;
T_WHITESPACE \n\n
T_PACKAGE package
T_WHITESPACE  
T_ID Test
T_WHITESPACE  
T_LCB {
T_WHITESPACE \n	
T_FUNC func
T_WHITESPACE  
T_ID main
T_LPAREN (
T_RPAREN )
T_WHITESPACE  
T_INTTYPE int
T_WHITESPACE  
T_LCB {
T_WHITESPACE \n		
T_ID print_string
T_LPAREN (
T_STRINGCONSTANT "\""
T_RPAREN )
T_SEMICOLON ;
T_WHITESPACE \n	
T_RCB }
T_WHITESPACE \n
T_RCB }
T_WHITESPACE \n
---- Actual ----
T_ID extern
T_WHITESPACE  
T_FUNC func
T_WHITESPACE  
T_ID print_string
T_LPAREN (
T_ID string
T_RPAREN )
T_WHITESPACE  
T_ID void

.
.
.
```
