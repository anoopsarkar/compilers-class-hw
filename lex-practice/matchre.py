import re
import sys
for line in sys.stdin:
    if re.match('^((a|b)+(b|c)+)+d$', line):
        print 'yes' 
    else:
        print 'no'
