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

# @alias extract, unarchive, expand
uncompress() {
  [ -f "$1" ] || return 2
  case $1 in
      *.tar.bz2|*.tbz2)  tar xvjf $1 && return;;
      *.tar.gz|*.tgz)    tar xvzf $1 && return;;
      *.bz2)             bunzip2 $1 && return;;
      *.rar)             unrar x $1 && return;;
      *.gz)              gunzip $1 && return;;
      *.tar)             tar xvf $1 && return;;
      *.zip)             unzip $1 && return;;
      *.Z)               uncompress $1 && return;;
      *.7z)              7z x $1 && return;;
  esac
  return 3
}
