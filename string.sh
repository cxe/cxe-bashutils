# @return remove leading and trailing whitespace
# @arg $1 string The string to be trimmed.
# @exitcode 2 Function missing arguments.
trim() {
    [[ $# = 0 ]] && printf "%s: Missing arguments\n" "${FUNCNAME[0]}" && return 2
    : "${1#"${1%%[![:space:]]*}"}"
    : "${_%"${_##*[![:space:]]}"}"
    printf '%s\n' "$_"
}

uppercase(){ local y="$*" && echo "${y^^}"; }
lowercase(){ local y="$*" && echo "${y,,}"; }
