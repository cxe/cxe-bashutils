# @alias sys_command, is_installed
is_available() {
    declare ref; if [[ "$1" == --var=* ]]; then ref="${1#*=}"; declare -n val="$ref"; shift; else local val; fi;
    [ "${is_available__cache["$1"]}" == "" ] && is_available__cache["$1"]=$( type -t -- "$1" 2>/dev/null )
    val="${is_available__cache["$1"]}"
    [ "$ref" ] || { [ "$val" ] && echo "$val"; }
    [ "$val" != "" ]
}

declare -A is_available__cache=()
