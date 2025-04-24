# Provides cached, cross-platform system info and template expansion.
# 
# @usage sys [-s|-v] <key> [args...]
#        <keys> type,version,is-linux,is-macos,is-windows,path-separator,file-separator,args-separator,host,user,root,arch,kernel,shell,tmpdir,get
#        
#        Examples:
#        if sys arch bits == 64; then ... fi | sys arch name | sys arch bits
#        sys type
#        sys -s is-windows && echo "You are running $(sys type) $(sys version) on $(sys host)"
#        sys -s is-windows && sys "%sys[user] running %sys[type] %sys[version] on %sys[host]"
#
# @options
#   -s     Silent mode: suppress output, return success/failure only
#   -v     Verbose mode: enable trace output for template substitution
#
sys() {
  local silent verbose

  # handle verbosity
  case "$1" in
    -s) silent=true; shift ;;
    -v) verbose=true; shift; set -x; trap 'set +x' RETURN;;
  esac

  # early exit if no key is requested
  [ "$1" ] || return 0

  # initialize sys cache
  if [ -z "${sys[type]}" ]; then
    declare -gxA sys

    # OS specifics
    sys["type name"]="$(uname -s)"
    case "${sys["type name"]}" in
      Linux*)
        sys[type]="Linux"
        sys[is-linux]="$( . /etc/os-release && echo "$NAME" )" # distro
        sys_version(){ sys[version]="$(. /etc/os-release && echo "$PRETTY_NAME")"; }
        sys[path-separator]=':'
        sys[file-separator]='/'
        sys[args-separator]='-'
        sys_get(){ echo -e "\e[31mFAILURE: sys_get not implemented\e[0m" >&2; exit 2; }
        sys[root]="/"
        ;;
      Darwin*)
        sys[type]="MacOS"
        sys[is-macos]="MAC"
        sys_version(){ sys[version]="$(sw_vers -productVersion)"; }
        sys[path-separator]=':'
        sys[file-separator]='/'
        sys[args-separator]='-'
        sys_get(){ echo -e "\e[31mFAILURE: sys_get not implemented\e[0m" >&2; exit 2; }
        sys[root]="/"
        ;;
      MINGW*|MSYS*|CYGWIN*)
        sys[type]="Windows"
        sys[is-windows]="WIN"
        sys_version(){ sys[version]="$(uname -s)" && sys[version]="${sys[version]#*-}"; }
        sys[path-separator]=';'
        sys[file-separator]="\\"
        sys[args-separator]='/'
        sys_get(){
          local key="${1//\\/\/}" && key="${key%%[:/]*}:/${key#*/}" # normalize to forward slashes and ensure hive ends with colon
          powershell.exe -NoProfile -Command "(Get-ItemProperty '$key')${2+".$2"}"
        }
        sys[root]="$( sys get "HKLM/SOFTWARE/Microsoft/Windows NT/CurrentVersion" SystemRoot )"
        ;;
      *)
        echo -e "\e[31mFAILURE: unknown sys type\e[0m" >&2
        exit 1
        ;;
    esac
  fi

  declare key val compare="" query="$*" result=""
  case "${@:$#-1:1}" in
    ==)
        compare="${@:$#-1:1}"
        query="${@:1:$#-2}"
        ;;
  esac
  
  if [ "${sys["$query"]+_}" ]; then
    result="${sys["$query"]+"${sys["$query"]}"}"
  else
    # ensure result is template string
    result="$query"; [[ "$result" == *"%sys["* ]] || result="%sys["$query"]"

    # replace all template variables
    while true; do
      key="${result#*%sys[}" && key="${key%%]*}"

      # process on-demand- or dynamic-keys
      [ "${sys["$key"]+_}" ] || {
        case "$1" in
          arch)
            sys[arch]="$(uname -m)"
            case "${sys[arch]}" in
                x86_64)           sys["arch name"]="AMD64"; sys["arch bits"]=64 ;;
                i[3-6]86)         sys["arch name"]="X86";   sys["arch bits"]=32 ;;
                aarch64)          sys["arch name"]="ARM64"; sys["arch bits"]=64 ;;
                arm*|armv[6-7]l)  sys["arch name"]="ARM";   sys["arch bits"]=32 ;;
                *)                sys["arch name"]="${sys[arch]}"; sys["arch bits"]="" ;;
            esac
            ;;
          host|hostname) sys[host]="$HOSTNAME";;
          kernel) sys[kernel]="$(uname -r)";;
          shell) sys[shell]="$SHELL";;
          get) sys["$query"]="$( sys_get "${@:2}" )";;
          tmpdir|tempdir) sys[tmpdir]="${TMPDIR:-/tmp}";;
          user|username) sys[user]="$USERNAME";;
          version) sys_version ;;
        esac
      }

      val="${sys["$key"]}"
      result="${result//"%sys[$key]"/"$val"}"
      
      [ "$verbose" ] && echo -e "\e[35m$result\e[0m"

      [[ "$result" == *%sys[* ]] || { sys["$query"]="$result"; break; }
    done
  fi

  case "$compare" in
    ==) # compare equality pattern
        [ "${@:$#:1}" ] && [[ "$result" == ${@:$#:1} ]]
        ;;
    *) # output value if not silent and return error code if key doesn't exist
        [ "$silent" ] || { [ "$result" ] && echo "$result"; }
        [ "${sys["$query"]+_}" ]
        ;;
  esac
}
