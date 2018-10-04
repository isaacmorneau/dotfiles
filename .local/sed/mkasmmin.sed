#doesnt check for string literals be warned
#remove excess whitespace
s/([ ]+)/ /g
#4 spaces indented
s/^[ ]+([^:]*)[ ]*$/    \1/g
#no spaces on labels
s/^[ ]*(.*:)[ ]*$/\1/g
#no multipule ;s
s/;+[ ]*/; /g
