
is_running() {
    [ $# -eq 0 ] && { echo "Usage: is_running <process_name> [more...]"; return 1; }
    for proc in "$@"; do pgrep -x "$proc" >/dev/null 2>&1 || return 2; done
}
