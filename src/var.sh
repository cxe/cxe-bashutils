
var(){
    local name temp
    for name; do
        temp=""
        if [[ "$name" == *=* ]]; then
            temp="${1#*=}"
            name="${name%%=*}"
        fi
        if [ "$name" ]; then
            local -n data="$name"
            if [ "$temp" ]; then
                data="$temp"
            fi
        fi
    done
}
