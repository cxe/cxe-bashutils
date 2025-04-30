cli(){
    declare item
    declare -A cfg=()
    for item; do [ "${item:0:1}" == - ] && cfg["$item"]="$item" && shift && continue; break; done

    local cmd="$1"; shift
    case "$cmd" in
        clear)
            clear
            ;;

        exit|fail|stop) # stop execution (fail and exit will terminate)
            local errno=0; [ "$cmd" == fail ] && errno=1; [[ "$1" =~ ^[0-9]+$ && "$1" -ge 0 && "$1" -le 255 ]] && { errno="$1"; shift; }
            [ "$1" ] && echo -e "\e[31m$*\e[0m" >&2
            [ "$cmd" == stop ] || exit $errno
            ;;

        reload) # reload the terminal
            for file in ~/.bashrc ~/.bash_profile ~/.profile
                do [ -s "$file" ] && source "$file" && break
            done
            clear
            ;;

        scripts) # list all loaded scripts
            /bin/bash -lixc exit 2>&1 | sed -n 's/^+* \(source\|\.\) //p'
            ;;

        vars) # list all loaded variables
            local key val
            compgen -v $* | while read key ; do
                val="${!key}"
                if [[ "$val" =~ ^[-+]?[0-9]*\.?[0-9]+$ ]]; then
                    val="\e[32m$val"
                else
                    val="${val//$'\r'/\\e[31;2;3m\\\\r\\e[39;22;23m}"
                    val="${val//$'\n'/\\e[31;2;3m\\\\n\\e[39;22;23m}"
                    val="${val//$'\t'/\\e[31;2;3m\\\\t\\e[39;22;23m}"
                    [[ "$key" == *PATH ]] && val="${val//:/\\e[31;1m:\\e[39;22m}"
                    val="\e[34m\"$val\""
                fi
                echo -e "\e[35m\"$key\"\e[37m: $val\e[0m"
            done
            ;;

        echo|info) # output (optionally formatted) text to stdout or stderr respectively
            local esc sos eos
            for opt in "${!cfg[@]}"; do
                case "$opt" in
                    -e) esc=-e;;
                    --bold) sos="$sos;1"; eos="$eos;22";;
                    --dim) sos="$sos;2"; eos="$eos;22";;
                    --italic) sos="$sos;3"; eos="$eos;23";;
                    --red) sos="$sos;31"; eos="$eos;39";;
                    --green) sos="$sos;32"; eos="$eos;39";;
                    --yellow) sos="$sos;33"; eos="$eos;39";;
                    --blue) sos="$sos;34"; eos="$eos;39";;
                    --pink) sos="$sos;35"; eos="$eos;39";;
                    --cyan) sos="$sos;36"; eos="$eos;39";;
                    --grey) sos="$sos;37"; eos="$eos;39";;
                esac
            done
            [ "$sos" ] && sos="\e[${sos:1}m" && eos="\e[${eos:1}m" && esc=-e
            if [ "$cmd" == info ]
                then echo $esc "$sos$*$eos" >&2
                else echo $esc "$sos$*$eos"
            fi
            ;;
        
        *)
            cli stop "unknown command 'cli $cmd'"
            ;;
    esac
}


