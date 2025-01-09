
if_sys(){ [ "$OSTYPE" == $1* ] || return 1; }
sys_arch(){ uname -m; }
