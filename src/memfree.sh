
memfree() {
    if command -v free >/dev/null; then
        free -h
    elif command -v vm_stat >/dev/null; then
        vm_stat | awk '
            /Pages free/     {free=$3}
            /Pages active/   {active=$3}
            END {
                page_size=4096
                printf "Free: %.2f MiB\n", free*page_size/1024/1024
                printf "Active: %.2f MiB\n", active*page_size/1024/1024
            }'
    else
        echo "Unsupported system"
        return 1
    fi
}
