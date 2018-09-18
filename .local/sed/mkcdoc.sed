/[a-zA-Z0-9_]+[ ]+[a-zA-Z0-9_]+\([^)]+\)[ ]*\{/ {
    #save the original line
    h

    #get the name
    s/[a-zA-Z0-9_]+[ ]+([a-zA-Z0-9_]+).*/\1/g
    #prepend start of comment
    s/^(.*)/\n\/\*\n \* function:\n \*    \1\n \*/g
    #print start of the comment
    p


    #clearout pattern space and restart
    s/.*//g
    G


    #get the return
    s/([a-zA-Z0-9_]+).*/\1/g
    #prepend lable
    s/^\n*(.*)/ \* return:\n \*    \1\n \*/g
    #print start of the comment
    p


    #clearout pattern space and restart
    s/.*//g
    G


    #get the arguments
    s/.*\(([^)]+)\).*/\1/g
    s/^[\n ]*(.*)/ \* parameters:\n \*    \1/g
    #indent and make all the lines *
    s/[ ]*,[ ]*/\n \*    /g
    #add multiline comment before and after
    s/$/\n \*\n \* notes:\n \*\n \* \*\/\n/g
    #print the arguments and the notes template
    p

    #print the original function
    g
}
