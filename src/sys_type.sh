sys_type(){
    [[ -z "${OSTYPE:-}" ]] && declare -gx OSTYPE="$(uname | tr '[:upper:]' '[:lower:]')"
    local os="${OSTYPE,,}"
    [ $# == 0 ] && echo "$os" && return
    local cond="${1:-}" && cond="${cond,,}"
    case "$cond" in
        mac|darwin|ios) [[ $os == darwin* ]] ;;
        linux|unix|gnu|solaris|android|sunos|bsd) [[ $os == *linux* || $os == *bsd* || $os == *solaris* || $os == *sunos* || $os == *android* || $os == *gnu* ]] ;;
        win) [[ $os == *cygwin* || $os == *mingw* || $os == *msys* || $os == *windows* || $os == win* ]] ;;
        *) [[ $os == "$cond"* ]] ;;
    esac
    return $?
}
