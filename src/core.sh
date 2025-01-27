#!/usr/bin/env bash

declare -F typeof >/dev/null 2>/dev/null || {

  # parse CLI arguments, options and flags
  # @usage: declare -A opts && args "$@"
  args(){
      local k v && declare -i i=0 n=${#@} && declare -n o=${_:-opts} a=args && a=()
      for ((i=1; i<=n; ++i)); do
          v="${!i}"
          case "$v" in
              --) a+=("${@:((i+1))}") && break;;
              --*=*) k="${v:2}" && k="${k%%=*}" && o["$k"]="${v#*=}";;
              --*) k="${v:2}" && o["$k"]="$k";;
              -[[:alpha:]]*) ;;
              *) a+=("$v");;
          esac
      done
  }

  # @return: array|boolean|builtin|file|function|number|object|string|undefined
  # @usage:  typeof <varname>|<command> [<matcher>] [<match>]
  #          if matchers are used no output is generated
  #          eg.: `if typeof foobar == function; then echo foobar is a function; fi`
  typeof(){
    local name="$1" data="${!1}" type=string
    if [[ "$name" =~ ^[_[:alpha:]][_[:alpha:][:digit:]]*$ ]]; then
      declare -a attr; read -ra attr < <( declare -p "$name" 2>/dev/null )
      case "${attr[1]}" in
        '')  type="$( type -t "$name" 2>/dev/null )" || type=undefined;;
        *A*) type=object; declare -n data="$name";;
        *a*) type=array; declare -n data="$name";;
        *i*) type=number;;
        *) if [[ "$data" == ?(-|+)+([0-9])?(.+([0-9])) ]]; then type=number
           elif [[ "$data" == @(true|false) ]]; then type=boolean; fi
      esac
    fi
    [ $# -lt 2 ] && echo $type || case "$2" in
      ===|==|=) [ "$type" == "$3" ] || return 2;;
      !=) [ "$type" != "$3" ] || return 2;;
      is) case "$3" in
          readonly) [[ "${attr[1]}" == *r* ]];;
          executable) [[ "$type" == @(builtin|file|function) ]];;
          empty) [ ${#data[@]} == 0 ];;
        esac ;;
      =~|matches) [[ "$data" =~ $3 ]];;
    esac
  }

  # read a line from a file
  # @param 1: line number (if none provided use calling line)
  # @param 2: file name (if none provided use current)
  readline(){ declare -a l && readarray -t l <"${2:-$BASH_SOURCE}" && echo "${l[${1:-$BASH_LINENO}-1]}"; }

  # terminal interaction functions
  is_terminal() { [[ -t 1 || -z ${TERM} ]] && return 0 || return 1; }

  # @usage: `dir_containing [--stop=<dir>] <sub-path-to-find>`
  # @params: 1) (sub-)filename to find, 2) starting-dir (defaults to PWD)
  # @options: --stop=<dir> directory where to stop searching (default: <root>)
  # @return: directory-path (where the (sub-)filename was found),
  #          otherwise empty string (along with a non-zero errorcode)
  # @throws: #400 if called without parameters, #404 if not found
  # @alias:  upfind, find_upward
  dir_containing() {
      local stop=""; [[ "$1" = --stop=* ]] && { stop="$( realpath "${1/--stop=/}" )"; shift; }
      [ "$1" ] || return 400
      local d="$( realpath "${2:-"$PWD"}" )"
      while [ "$d" ] && [ "$d" != "$stop" ] && [ ! -e "$d/$1" ]; do d="${d%/*}"; done
      [ -e "$d/$1" ] && echo "${d:-/}" || return 404
  }

  echorun(){
    cmd="$1"
    args="${@:2}"
    >&2 echo -e "\033[1;36m${cmd}\033[0;36m ${args}\033[0m"
    [ -z $DRY ] && $cmd $args
  }


  # @usage FOO="$(findUpwardFile foo.txt)"
  readUpwardFile() {
      echo "$(f=/$1; d="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"; while [ "$d" != "/" ]; do [ -f "$d$f" ] && echo "$d$f"; d="$(dirname "$d")"; done)"
  }

  fail(){
    declare -i errno=0 && [[ "$1" = [[:digit:]] ]] && (( $1 > 0 && $1 <= 255 )) && errno="$1" && shift
    >&2 echo -e "\033[31mError #$errno: $* at ${BASH_SOURCE[2]}:${BASH_LINENO[1]}\033[0m"
    exit $errno
  }
}
