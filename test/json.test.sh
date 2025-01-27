#!/usr/bin/env bash

source "${BASH_SOURCE[0]%/*}/../test.sh"
source "${BASH_SOURCE[0]%/*}/../json.sh"

test_json_file(){
    declare -r file="$1"
    [ -e "$file" ] || return 104
    declare name="${file%.*}" && declare -r name="${name##*/}"
    declare -r data="$(<"$file")"
    
    describe "$name"

    describe::end
}

find "${BASH_SOURCE[0]%/*}/files" -name '*.json' -type f -print0 | while IFS= read -r -d '' f; do test_json_file "$f"; done
