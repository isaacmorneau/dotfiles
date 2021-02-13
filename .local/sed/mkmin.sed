:t
N
#delete comments
s/[ ]*#[^\/]*$//g
#delete comments that for some reason have forward slashes
s/^[ ]*#.*$//g
#delete front whitespace
s/\n[\n ]+/\n/g
#keep doing this to the whole file
$!bt
#delete newlines
s/\n/;/g
#fun fact this works on itself
