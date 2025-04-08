sys_type(){
    [[ -z "${OSTYPE:-}" ]] && declare -gx OSTYPE="$(uname | tr '[:upper:]' '[:lower:]')"
    local os="${OSTYPE,,}"
    [ $# == 0 ] && echo "$os" && return
    local cond="${1:-}" && cond="${cond,,}"
    case "$cond" in
        mac|darwin|ios) [[ $os == darwin* ]] ;;
        linux|unix) [[ $os == *linux* || $os == *bsd* || $os == *solaris* || $os == *android* || $os == *gnu* ]] ;;
        win) [[ $os == *cygwin* || $os == *mingw* ]] ;;
        *) [[ $os == "$cond"* ]] ;;
    esac
    return $?
}
