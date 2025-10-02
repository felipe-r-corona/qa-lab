#!/bin/bash

HOSTNAME="$1"
IP="$2"
ENTRY="$IP $HOSTNAME"
HOSTS_FILE="/etc/hosts"
TMP_FILE="/tmp/hosts.tmp"

# Filter out exact matches of the entry
grep -v -x "$ENTRY" "$HOSTS_FILE" > "$TMP_FILE"

# Overwrite hosts file with deduped content
sudo cp "$TMP_FILE" "$HOSTS_FILE"

# Append the new entry
echo "$ENTRY" | sudo tee -a "$HOSTS_FILE" > /dev/null

# Restart dnsmasq
sudo systemctl restart dnsmasq
