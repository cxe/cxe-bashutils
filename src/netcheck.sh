
netcheck() {
  host="$1"; ping -c1 "$host" && nslookup "$host" && curl -I "https://$host"
}
