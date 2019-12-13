#!/usr/bin/bash

path=${1:-'./'}

listing=$(find "${path}" -type f)
file=$(mktemp)
cat > "${file}" <<< "${listing}"
$EDITOR "$file"
newlisting=$(<"${file}")

orig=( ${listing} )
new=( ${newlisting} )

#while IFS= read -r line; do
#    orig+=("${line}")
#done <<< "${listing}"
#
#while IFS= read -r line; do
#    new+=("${line}")
#done <<< "${listing}"

for i in "${!orig[@]}"; do
    a="${orig[${i}]}"
    b="${new[${i}]}"
    if [ "${a}" = "${b}" ]; then
        continue
    fi
    echo "mv '${a}' '${b}'"
done

echo "rm '${file}'"
