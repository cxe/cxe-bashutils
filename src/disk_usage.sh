
disk_usage() {
    df -h / | awk 'NR==2 { print "Used:", $3, "| Free:", $4, "| Usage:", $5 }'
}
