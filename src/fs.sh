#!/usr/bin/env bash

# @return a) string, scheme of URL (or "file" if filename exists)
#         b) if multiple params are given returns 0 only if type of first param matches one of the provided others
# @param: URL or filename
# @param(s): URL types to check for match
# @effect sets global variables: url_type, url_data, url_user, url_pass, url_host, url_port, url_path, url_query
# @alias is_url parse_url
# @usage `if url_type "$url" file http ftp; then ...`
url_type(){
  local t && declare -gx url_type="" url_user="" url_pass="" url_path="" url_data="$1" url_query="" && shift
  if [[ "$1" == *?* ]]; then
    url_data="${1%%$'?'*}"
    url_query="${1#*$'?'}"
  fi
  if [[ "$url_data" == *://* ]]; then
    url_type="${url_data%%:*}" && url_type="${url_type,,}"
    url_data="${url_data:((${#url_type}+3))}"
  elif [ -e "$url_data" ]; then
    url_type="file"
  fi
  case "$url_type" in
    "") return 1;;
    file)
      url_path="$url_data";;
    http|https|ftp|sftp)
      url_path="/${url_data#*\/}"
      url_host="${url_data%%\/*}"
      if [[ "$url_host" == *@* ]]; then
        url_user="${url_host%%@*}"
        if [[ "$url_user" == *:* ]]; then
          url_pass="${url_user#*:}"
          url_user="${url_user%%:*}"
        fi
        url_host="${url_host#*@}"
        if [[ "$url_host" == *:* ]]; then
          url_port="${url_port#*:}"
        fi
      fi
      ;;
  esac
  if [ "$#" -eq 0 ]; then
    echo "$url_type"
  else
    for t; do [ "${t,,}" == "$url_type" ] && return; done
    return 2
  fi
}

is_dir(){ [ -d "$1" ]; }

is_link(){ [ -l "$1" ]; }

is_file(){ [ -f "$1" ]; }

# @alias exists
is_fso(){ [ -e "$1" ]; }

# @usage `while file_list . '*.sh'; do : ; done`
file_list(){
  declare -n _file=file
  [ "$file_list_dir" ] || {
    declare -gx file_list=() file_list_dir="$1"
    while IFS= read -r -d '' f; do file_list+=("$f"); done < <( find "${1:-$PWD}" -name "${2:-*}" -type f -print0 )
  }
  if [ ${#file_list} == 0 ]; then
    _file='' && file_list_dir="" && return 2
  else
    _file="${file_list[0]}"
    file_list=("${file_list[@]:1}")
  fi
}

# remove all subdomains
url_rootdomain() { echo "$1" | rev | cut -d "." -f1-2 | rev; }

# get all subdomains
url_subdomain() { echo "$1" | sed "s/\.$(url_rootdomain "$1")//g"; }

