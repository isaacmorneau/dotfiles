/^([a-z_]+:)/ {
    #save the original line
    h
    #add some default comment values
    s/([a-z_]+):/; function:\n;     \1\n;\n; parameters:\n;    eax\n;\n; return:\n;    eax\n;\n;  notes:\n;   /g
    #print it
    p
    #print the original label
    g
}
