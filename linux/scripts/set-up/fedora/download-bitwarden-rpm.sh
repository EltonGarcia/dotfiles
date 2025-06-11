#!/usr/bin/env bash

# exit on error
set -e

# Fetch latest Bitwarden CLI version from GitHub API
echo "🌐 Fetching latest Bitwarden CLI version..." >&2
ASSETS=$(curl -s "https://api.github.com/repos/bitwarden/clients/releases/latest")
NAME=$(echo "$ASSETS" | jq '.assets.[].name' -r | grep 'x86_64' | grep '.rpm')

if [ -z "$NAME" ]; then
    echo "❌ Failed to fetch latest version" >&2
    exit 1
fi

# Construct download URL
BW_URL=$(echo "$ASSETS" | jq '.assets.[] | select(.name == "Bitwarden-2025.5.1-x86_64.rpm") | .browser_download_url' -r)
RPM_DIR="/tmp/rpms"
RPM_FILE="$RPM_DIR/$NAME"

mkdir -p "$RPM_DIR" 

echo "⬇️ Downloading Bitwarden .." >&2
curl -L -o "$RPM_FILE" "$BW_URL" || {
    echo "❌ Download failed. Check URL: $BW_URL" >&2
    exit 1
}

echo "rpm downloaded to $RPM_FILE" >&2

echo $RPM_FILE
exit 0
