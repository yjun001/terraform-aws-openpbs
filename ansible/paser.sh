#!/usr/bin/env bash
set -eo pipefail

# step 1. load/parse data from file 
CONFIG=$(cat $1 | egrep -v "#|^$|^[a-zA-Z]+$|\[|\]" | 
    sed -E 's/[[:space:]]+ansible_host//g' | 
    jq -R -n -c '.data = ([inputs|split("=")|{(.[0]):.[1]}] |add)')
# step 2. parse input arguments
if [[ $2 != '' ]]; then
    OUTPUT=$(echo $CONFIG | jq -r '.data["'$2'"]')
else
    OUTPUT=$(echo $CONFIG | jq -r '.data')
fi
# step 3. return query
#jq -n --arg output "$OUTPUT" '{"output":$output}'
echo -n "$OUTPUT"