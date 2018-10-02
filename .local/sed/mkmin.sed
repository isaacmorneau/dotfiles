:top
N
#delete comments
s/[ ]*#.*$//g
#delete front whitespace
s/^[ ]*//g
#keep doing this to the whole file
$!btop
#delete newlines
s/[ ]*\n+[ ]*/;/g
