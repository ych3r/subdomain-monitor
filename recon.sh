#!/bin/bash

if [ -z "$1" ]; then
    echo "Error: Missing target. Please provide a domain name, e.g. example.com."
    exit 1
fi

echo "[+] Load .env file..."
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
fi

DOMAIN=$1
FOLDER="targets/$DOMAIN"
RAW="$FOLDER/subdomains_raw.txt"
HISTORY="$FOLDER/history.txt"
NEW="$FOLDER/new_subdomains.txt"

mkdir -p "$FOLDER"
touch "$HISTORY"

echo "[+] Run 'subfinder'..."
subfinder -d $DOMAIN -silent > $RAW
echo "[+] Run 'assetfinder'..."
assetfinder --subs-only $DOMAIN >> $RAW
echo "[+] Deduplicate raw subdomains..."
CLEANED=$(cat "$RAW" | tr '[:upper:]' '[:lower:]' | sort -u)
echo "[+] Compare to history.txt..."
echo "$CLEANED" | comm -23 - "$HISTORY" > "$NEW"
echo "[+] Append new domains to history.txt..."
cat "$NEW" >> "$HISTORY"
sort -u "$HISTORY" -o "$HISTORY"

echo "[+] Run 'httpx'..."
cat $NEW | httpx -mc 200,301,302 -silent -status-code -title -tech-detect -no-color > "$FOLDER/new_live_hosts.txt"

echo "✅ Found $(wc -l < "$NEW") new subdomains"

echo "[+] Send Discord notification..."
CONTENT="🌐 **New live hosts found for \`$DOMAIN\`**"
while IFS= read -r line; do
  CONTENT+="
$line"
done < <(head -n 10 "$FOLDER/new_live_hosts.txt")
PAYLOAD=$(jq -n --arg content "$CONTENT" '{content: $content}')
curl -s -X POST -H "Content-Type: application/json" -d "$PAYLOAD" "$WEBHOOK_URL"
echo "[+] Done"
