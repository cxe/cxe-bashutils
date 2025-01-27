#!/usr/bin/env bash

source "${BASH_SOURCE[0]%/*}/../src/test.sh"
source "${BASH_SOURCE[0]%/*}/../src/json.sh"

test_json_file(){
    declare -r file="$1"
    [ -e "$file" ] || return 104
    declare name="${file%.*}" && declare -r name="${name##*/}"
    declare -r data="$(<"$file")"

    describe "$name"

    describe::end
}

while file_list "${BASH_SOURCE[0]%/*}/files" '*.json'; do test_json_file "$f"; done
