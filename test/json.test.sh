#!/usr/bin/env bash

source "${BASH_SOURCE[0]%/*}/../lib/spec"
source "${BASH_SOURCE[0]%/*}/../lib/json"

test_json_file(){
    declare -r file="$1"
    [ -e "$file" ] || return 104
    declare name="${file%.*}" && declare -r name="${name##*/}"
    declare -r data="$(<"$file")"

    describe "$name"

    describe::end
}

while file_list "${BASH_SOURCE[0]%/*}/files" '*.json'; do test_json_file "$f"; done
