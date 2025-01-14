#!/usr/bin/env bash

declare -F json >/dev/null 2>/dev/null || {
  json(){
    declare -x JSON_URL=""
    declare -x JSON_SRC=""
    declare -xa JSON_ERR=()
  }
}
