
if_os() { [ "$OSTYPE" == $1* ] || return 1; }
