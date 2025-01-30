#!/usr/bin/env bash

declare -F log >/dev/null 2>/dev/null || {
  log(){
    local cmd="$*" txt="$*"
    if [[ "${cmd}" == mkdir* ]]; then
      txt="create directory '${@:(($#))}'"
    fi
    if "$@"; then
      >&2 echo -e "$? \033[31m$txt\033[0m"
    else
      >&2 echo -e "$? \033[31mError: $txt at ${BASH_SOURCE[1]}:${BASH_LINENO[0]}\033[0m"
    fi 
  }
}
