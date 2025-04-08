
# parse arguments into `args`, options and flags into `opts`
# @usage: declare -A opts=() && declare -a args && args "$@" && set -- "${args[@]}"
#         opts can define option-default-values
#         short to long option mapping supported by -* keys in opts
#         example: declare -A opts=( [-e]=--export [--export]=+@ ) && declare -a args && args "$@"
args(){
    declare f i j k l m n v
    declare -a tmp=()
    declare -n a=args o=opts && args=()
    declare -A alias=() eager=() array=() combi=()

    [ "$VERBOSE" ] && echo -e "\033[36;1m${*}\033[36;22m" 2>&1

    # apply option-settings (opts[-*])
    for k in "${!opts[@]}"; do
        [[ "$k" == -* ]] || continue
        v="${opts[$k]}" && unset 'opts[$k]'
        [[ $v == *@* ]] && array["$k"]=0
        [[ $v == *+* ]] && eager["$k"]="+"
        [[ $v == *?* ]] && combi["$k"]="?"
        [[ $v == *-* ]] && alias["$k"]="${v//[+@]/}"
    done

    #normalize input
    n=$#; i=0; while (( ++i<=n )); do
        k="${!i}"; v=1

        # non-dash items are considered args (if not preceeded by eager option)
        [[ "$k" != -* ]] && tmp+=("$k") && continue

        # stop option parsing on double-dash
        [ "$k" == -- ] && tmp+=(-- "${@:i+1}") && break

        # separate key from value if assignment exists
        if [[ "$k" == -*=* ]]; then v="${k#*=}"; k="${k%%=*}"; fi

        # check if key has an alias
        [ "${alias["$k"]}" ] && k="${alias["$k"]}"

        # double-dash option (GNU long-form flag-style w/o value) or single-dash-name
        if [[ "$k" == --* ]] || [[ "$k" == "${alias["$k"]//[@+?]/}" ]]; then
            [ "${eager["$k"]}" ] && { ((++i)); v="${!i}"; }
            tmp+=("$k=$v") && continue
        fi

        # single-dash gouped short option flags (attached-combi, assigned-value, or eager-space-separated)
        f="$k"; j=0; m=${#f}
        while (( ++j < m )); do
            k="-${f:j:1}"; v=1
            [ "${alias["$k"]}" ] && k="${alias["$k"]}"
            [ "${combi["$k"]}" ] && { v="${f:2}"; j=m; }
            [ "${eager["$k"]}" ] && { ((++i)); v="${!i}"; }
            tmp+=("$k=$v")
        done
    done

    # process normalized items
    for i in "${!tmp[@]}"; do
        v="${tmp[i]}"
        [[ "$v" != -* ]] && a+=("$v") && continue
        [ "$v" == -- ] && a+=("${tmp[@]:i+1}") && break
        k="${v%%=*}"; v="${v#*=}"
        f="${k#*-}" && f="${f#*-}" && f="${f//-/_}"
        if [ "${array["$k"]}" ]; then
            [ "${o["${f}_list"]}" ] && o["${f}_list"]="${o["${f}_list"]} '$v'" || o["${f}_list"]="'$v'"
            (( array["$k"]++ ))
        fi
        [ "$f" ] && o["$f"]="$v"
    done

    [ "$VERBOSE" ] && { declare -p args opts 2>&1; echo 2>&1; declare -p alias eager array tmp 2>&1; echo -e "\033[0m" 2>&1; }
}
