#!/usr/bin/env bash

# @return remove leading and trailing whitespace
# @arg $0 (default: "\t\r\n\f\v ")
# @arg $1 string
# @option -n nameref
# @exitcode 1 invalid arguments
str_trim() {
  local ref=""; [ $1 == -n ] && { ref="$1" && declare -n v="$2"; shift 2; } || local v
  local ban="\r\n\t\f\v "; [ $# -gt 1 ] && ban="$1" && shift
  v="${1#"${1%%[!"$ban"]*}"}" && v="${v%"${v##*[!"$ban"]}"}"
  [ "$ref" ] || echo "$v";
}

# @return uppercase string
# @arg $1 string
# @option -n nameref
str_upper(){ local ref=""; [ $1 == -n ] && { ref="$1" && declare -n v="$2"; shift 2; } || local v; v="${1^^}"; [ "$ref" ] || echo "$v"; }

# @return lowercase string
# @arg $1 string
# @option -n nameref
str_lower(){ local ref=""; [ $1 == -n ] && { ref="$1" && declare -n v="$2"; shift 2; } || local v; v="${1,,}" ; [ "$ref" ] || echo "$v"; }

# @return a string repeated several times
# @arg $1 integer, number of times to repeat
# @arg $2 string, the string to be repeated
# @option -n nameref
# @exitcode 1 invalid arguments
# @usage `declare l && str_repeat $_ 80 -; echo $l`
str_repeat(){
  local ref=""; [ $1 == -n ] && { ref="$1" && declare -n v="$2"; shift 2; } || local v
  if [ "$2" == '' ] || (( $1 < 1 )); then return 1; fi
  v="$2" && while (( ${#v} < $1 )); do v="$v$v"; done; v="${v:0:$1}"
  [ "$ref" ] || echo -n "$v"
}

is_email() {
    declare regex; regex="^([A-Za-z]+[A-Za-z0-9]*\+?((\.|\-|\_)?[A-Za-z]+[A-Za-z0-9]*)*)@(([A-Za-z0-9]+)+((\.|\-|\_)?([A-Za-z0-9]+)+)*)+\.([A-Za-z]{2,})+$"
    [[ "$1" =~ $regex ]] && return 0
    return 1
}


