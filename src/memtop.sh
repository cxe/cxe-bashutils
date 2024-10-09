# display top 10 processes by memory usage
memtop() {
    ps aux --sort=-%mem | awk 'NR==1 || NR<=11'
}
