#!/usr/bin/env bash

# check if OS is linux, win, ios (or specific OS)
sys_type(){
  local os="${OSTYPE,,}"
  case "${1,,}" in
    mac|darwin|ios) [ $os == darwin* ] && return 0;;
    linux|unix) if [[ $os == *linux* ]] || [[ $os == *bsd* ]] || [[ $os == *solaris* ]] || [[ $os == *android* ]] || [[ $os == *gnu* ]] then return 0; fi
    win) if [[ $os == *cygwin* ]] || [[ $os == *mingw* ]] then return 0; fi
    *) [[ $os == $1* ]] && return 0
  esac
  return 1
}

# OS architecture
sys_arch(){ uname -m; }

# check if a command is a path-binary
sys_path_bin(){ builtin type -P "$1" &> /dev/null; }
