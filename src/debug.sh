local result_name="" result_data timeout=2 verbose=false

declare -a args=()
while [[ $# -gt 0 ]]; do
    case "$1" in
        -n)
            declare result_name="$2" && declare -n result_data="$result_name" && shift
            ;;
        *)
            args+=("$1")
            ;;
    esac
    shift
done
set -- "${args[@]}" && result_data=""

case "$1" in
    sources|imports)
        # list scripts that are currently loaded
        /usr/bin/env bash -lixc exit 2>&1 | sed -n 's/^+* \(source\|\.\) //p'
        ;;
    var-source)
        # list scripts that define a variable
        # @usage: e.g. `debug_varfile PATH`
        /usr/bin/env bash -lixc exit 2>&1 | sed -n 's/^+* \(source\|\.\) //p' | while read f ; do
            local data="$( fs_data "$f" )"
            if [[ "$data" == *"$1"=* ]]; then echo "$f"; fi
        done
        ;;
esac
    