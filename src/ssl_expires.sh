
ssl_expires() {
    local domain="$1"
    if [ -z "$domain" ]; then
        echo "Usage: ssl_expires <domain>"
        return 1
    fi

    echo | openssl s_client -servername "$domain" -connect "$domain:443" 2>/dev/null |
        openssl x509 -noout -dates
}
