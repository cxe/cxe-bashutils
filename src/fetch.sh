# Fetches URL into variable or stdout - failing on non-2xx; sets fetch_url, fetch_status, fetch_content
# @alias request, url_content
fetch() {
    declare ref; if [[ "$1" == --var=* ]]; then ref="${1#*=}"; declare -gxn fetch_content="$ref"; shift; else declare -gx fetch_content; fi;
    declare -gx fetch_url="$1" fetch_status=""
    [ "$fetch_url" ] || return 1
    fetch_content="$(curl -sLk --max-time 3 -w '%{http_code}' -o - -- "$fetch_url")" || return 2
    fetch_status="${fetch_content: -3}"; fetch_content="${fetch_content:: -3}"
    [[ "$fetch_status" = 2* ]] || return 3
    if [ ! "$ref" ]; then printf '%s' "$fetch_content"; fi
}
