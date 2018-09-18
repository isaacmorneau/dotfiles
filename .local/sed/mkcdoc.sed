/[a-zA-Z0-9_]+[ ]+[a-zA-Z0-9_]+\([^)]+\);/ {
    #if we are here its already a function, save the line
    h
    s/[a-zA-Z0-9_]+[ ]+[a-zA-Z0-9_]+\(([^)]+)\);/\1/g
    #indent and make all the lines
    s/,/\n/g
    s/^([ ]*)(.*)$/ \*    \2\n/g
    #add multiline comment before and after
    s/^/\/\*\n/g
    s/$/\n \*\//g
    #print the comment
    p
    #print the original function
    g
}
