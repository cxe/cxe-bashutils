
# @usage: stream_into echo
# @alias fileline
stream_into() {
    local file= cmd= timeout= line=

    if [ -f "$1" ]; then
        file="$1"
        shift
    fi

    cmd="${1:-echo}"
    timeout="${2:-1}"

    command -v "$cmd" >/dev/null || { echo "Command not found: $cmd" >&2; return 1; }

    if [ -n "$file" ]; then
        while IFS= read -rt "$timeout" line; do
            "$cmd" "$line"
        done < "$file"
    else
        while IFS= read -rt "$timeout" line; do
            "$cmd" "$line"
        done
    fi
}
