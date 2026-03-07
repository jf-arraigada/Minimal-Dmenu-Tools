#!/usr/bin/env bash

CACHE_DIR="$HOME/.cache/wifi_daemon"
CACHE_FILE="$CACHE_DIR/cache.txt"
TMP_FILE="$CACHE_DIR/cache.tmp"

mkdir -p "$CACHE_DIR"

SCAN_DELAY=1

update_cache() {
    nmcli -t -f SSID,RATE,BARS,SECURITY device wifi list --rescan no |
    awk -F: '
    !seen[$1]++ && $1!="" {
        printf "%s|%s|%s|%s\n", $1,$2,$3,$4
    }' > "$TMP_FILE"

    mv "$TMP_FILE" "$CACHE_FILE"
}

# Initial scan
update_cache

# Event loop reactivo
nmcli monitor |
while read -r line; do

    # Debounce: evita múltiples scans seguidos
    sleep "$SCAN_DELAY"

    # Solo actualizar cache si hay cambio visible
    update_cache

done
