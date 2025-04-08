# CSV Utility Library
# @usage:
#   declare -a data
#   csv parse "input.csv" data ";"
#   csv save "output.csv" data ","
csv(){
    local cmd="$1" file="$2" delimiter="${3:-;}"
    [[ "$file" && "$2" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]] || return 1
    local -n ref_data="$2"; ref_data=()

    case "$cmd" in
        parse)
            [[ -s "$file" ]] || return 2
            local IFS= row=() field="" q=0 l
            while IFS= read -r l || [[ $l ]]; do
                l+=$'\n'
                while IFS= read -r -n1 c; do
                    case "$c" in
                        '"') ((q ^= 1)); [[ ${field: -1} == '"' ]] && field="${field%\"}\"" ;;
                        "$delimiter") [[ q -eq 0 ]] && { row+=("$field"); field=""; continue; } ;;
                        '') [[ q -eq 0 ]] && { row+=("$field"); ref_data+=("$row"); row=(); field=""; break; } || field+=$'\n' ;;
                        *) field+="$c" ;;
                    esac
                done <<< "$l"
            done < "$file"
            ;;
        save)
            [[ ${#ref_data[@]} -gt 0 ]] || return 3
            {
                for row in "${ref_data[@]}"; do
                    local output=()
                    for field in "${row[@]}"; do
                        [[ "$field" =~ [$delimiter\"\n] ]] && field="\"${field//\"/\"\"}\""
                        output+=("$field")
                    done
                    printf "%s\n" "$(IFS="$delimiter"; echo "${output[*]}")"
                done
            } > "$file"
            ;;
        *) return 4 ;;  # Invalid command
    esac
}