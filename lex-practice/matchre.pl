while (<>) {
    chomp($_);
    if ( m/^((a|b)+(b|c)+)+d$/ ) {
        print "yes\n";
    } else {
        print "no\n";
    }
}
