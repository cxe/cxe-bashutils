# ls() - Enhanced ls for Git Bash (or Linux)
# Also lists mounted drives (e.g. /c, /d) or remote NFS mounts when in root (/)
# @override
ls() {
    command ls "$@" || return
    [[ "$PWD" == "/" ]] || return

    # Only show mountpoints if no explicit paths were given
    for arg in "$@"; do
        [[ "$arg" == /* && -e "$arg" ]] && return
    done

    # NFS-style mounts
    awk '$1 ~ /:\/.*$/ {print $2}' /proc/mounts | while read -r mnt; do
        command ls "$mnt" "$@" 2>/dev/null
    done

    # Windows-style drive mounts
    for drive in /[a-z]; do
        [[ -d "$drive" ]] && command ls "$drive" "$@" 2>/dev/null
    done
}