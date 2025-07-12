#!/usr/bin/env bash
set -euo pipefail

THEME_VARIANT="${1:-night}"
THEME_NAME="tokyonight_${THEME_VARIANT}"
THEME_FILE="${THEME_NAME}.tmTheme"
THEME_DIR="$(bat --config-dir)/themes"
CONFIG_FILE="$(bat --config-dir)/config"

mkdir -p "$THEME_DIR"

curl -fsSL -o "$THEME_DIR/$THEME_FILE" \
  "https://raw.githubusercontent.com/folke/tokyonight.nvim/main/extras/sublime/$THEME_FILE"

bat cache --build

bat --list-themes | grep --color=always "$THEME_NAME" || {
  echo "Theme $THEME_NAME not found after build"
  exit 1
}

if ! grep -q -- "--theme=\"$THEME_NAME\"" "$CONFIG_FILE" 2>/dev/null; then
  echo "--theme=\"$THEME_NAME\"" >> "$CONFIG_FILE"
fi
