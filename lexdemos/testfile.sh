# accepts token 'a' : demo1
echo "a" | ./demo1
echo "aa" | ./demo1
echo "ab" | ./demo1

# accepts tokens 'a' or 'b' : demo2
echo "ab" | ./demo2
echo "abab" | ./demo2

# accepts asterisk using backslash escape char : demo3
echo "*" | ./demo3
echo "**" | ./demo3

# accepts two asterisks using literal string  : demo4
echo "**" | ./demo4
echo "***" | ./demo4
echo "****" | ./demo4

# accepts token that starts with 'a' and ends in 'b' using .* : demo5
echo "ab" | ./demo5
echo "aaabb" | ./demo5
echo "abcdefgb" | ./demo5
echo "abc" | ./demo5
echo "ac" | ./demo5

# accepts token that begins with abc : demo6
echo "abc" | ./demo6
echo "abcd" | ./demo6
echo "abcabc" | ./demo6

# accepts token that ends with abc : demo7
echo "abc" | ./demo7
echo "ab" | ./demo7
echo "dabc" | ./demo7
echo "abcabc" | ./demo7

# range of characters from a to z : demo8
echo "a" | ./demo8
echo "b" | ./demo8
echo "pqr" | ./demo8
echo "1" | ./demo8
echo "pqr1" | ./demo8

# range of characters not a to z : demo9
echo "1" | ./demo9
echo "123" | ./demo9
echo "a" | ./demo9
echo "12a\c" | ./demo9

# zero or more a's:a* :  demo10
echo "" | ./demo10
echo "a" | ./demo10
echo "aa" | ./demo10
echo "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" | ./demo10

# one or more a's:a+ :  demo11
echo "" | ./demo11
echo "a" | ./demo11
echo "aa" | ./demo11
echo "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" | ./demo11

# zero or one a = a? :  demo12
echo "" | ./demo12
echo "a" | ./demo12
echo "aa" | ./demo12

# between 2 and 3 a's = a{2,3} : demo13
echo "" | ./demo13
echo "a" | ./demo13
echo "aa" | ./demo13
echo "aaa" | ./demo13
echo "aaaa" | ./demo13

# a followed by b = ab : demo14
echo "a" | ./demo14
echo "ab" | ./demo14
echo "aba" | ./demo14
echo "abab" | ./demo14

# a or b = a|b : demo15
echo "a" | ./demo15
echo "b" | ./demo15
echo "ab" | ./demo15
echo "abab" | ./demo15

# b zero or more times or a = a|b* : demo16
echo "" | ./demo16
echo "a" | ./demo16
echo "b" | ./demo16
echo "abbbb" | ./demo16
echo "aaaabbbbbbbb" | ./demo16

# a or b zero or more times = (a|b)* : demo17
echo "" | ./demo17
echo "a" | ./demo17
echo "b" | ./demo17
echo "ab" | ./demo17
echo "abab" | ./demo17
echo "abba" | ./demo17
echo "abbaabba" | ./demo17
echo "aaaaa" | ./demo17
echo "bbbbb" | ./demo17

# note that a* could be empty and b* could be empty in a*b*c : demo18
echo "aaabbbc" | ./demo18
echo "aaabbb" | ./demo18
echo "bbbc" | ./demo18
echo "aaac" | ./demo18
echo "c" | ./demo18

# rightcontext1
echo "ab" | ./rightcontext1
echo "ac" | ./rightcontext1
echo "abc" | ./rightcontext1

# rightcontext2
echo "abcca" | ./rightcontext2

# leftcontext-inp
echo "inputfile \"filename\"" | ./leftcontext-inp

# leftcontext
echo "outputfile \"filename\"" | ./leftcontext
echo "inputfile \"filename\"" | ./leftcontext

# simplebigram
echo "the cat on the mat saw the cat on the cat box on the mat spit" | ./simplebigram

# bigram
echo "the cat on the mat saw the cat on the cat box on the mat spit" | ./bigram


