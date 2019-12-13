#!/usr/bin/bash

path=${1:-'./'}

listing=$(find "${path}" -type f)
file=$(mktemp)
cat > "${file}" <<< "${listing}"
$EDITOR "$file"
newlisting=$(<"${file}")

orig=( ${listing} )
new=( ${newlisting} )

for i in "${!orig[@]}"; do
    a="${orig[${i}]}"
    b="${new[${i}]}"
    if [ "${a}" = "${b}" ]; then
        continue
    fi
    mv "${a}" "${b}"
done

rm "${file}"
