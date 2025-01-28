#!/usr/bin/env bash

# unit testing for bash scripts
declare -F describe >/dev/null 2>/dev/null || {
    source "${BASH_SOURCE[0]%/*}/string.sh"

    declare -gxa TEST_GROUP=()
    declare -gxa TEST_NAME=()

    describe(){
        TEST_GROUP=("$*" "${TEST_GROUP[@]}")
    }

    describe::end(){
        declare -ir group_depth=${#TEST_GROUP[@]}
        local indent && str_repeat -n indent $(( group_depth -1 )) '  '
        >&2 echo -e "\033[31m$indent✘ ${TEST_GROUP[0]}\033[0m"
        TEST_GROUP=("${TEST_GROUP[@]:1:(($group_depth-1))}");
    }

    it(){
        TEST_NAME=("$*" "${TEST_NAME[@]}")
    }

    ti(){
        TEST_NAME=("${TEST_NAME[@]:1:((${#TEST_NAME[@]}-1))}");
    }
}
