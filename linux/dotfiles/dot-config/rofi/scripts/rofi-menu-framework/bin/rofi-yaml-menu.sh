#!/usr/bin/env bash
# Execute: 
#  rofi -show test \
#    -modi "test:$HOME/.config/rofi/scripts/rofi-menu-framework/bin/rofi-yaml-menu.sh $HOME/.config/rofi/scripts/rofi-menu-framework/menus/test.yml" \
#    -run-command '{cmd} {info}'

set -eo pipefail

MENU_FILE="$1"
STATE="${ROFI_INFO:-main}"

echo "INFO=$ROFI_INFO RETV=$ROFI_RETV 1=$1 2=$2" >&2

# ─────────────────────────────
# Helpers
# ─────────────────────────────

title_root() {
  yq -r '.title' "$MENU_FILE"
}

breadcrumb() {
  local path="$1"
  local title
  title="$(title_root)"

  IFS='/' read -ra parts <<< "$path"
  for p in "${parts[@]}"; do
    [[ "$p" == "main" ]] && continue
    label="$(yq -r ".menus.$p.label // empty" "$MENU_FILE")"
    [[ -n "$label" ]] && title+=" › ${label#* }"
  done

  echo "$title"
}

emit_prompt() {
  printf "\0prompt\x1f%s\n" "$(breadcrumb "$STATE")"
}

emit_item() {
  # display\0info\x1fstate\n
  printf "%s\0info\x1f%s\n" "$1" "$2"
}

parent_state() {
  [[ "$STATE" != *"/"* ]] && echo "main" || echo "${STATE%/*}"
}

# ─────────────────────────────
# Renderers
# ─────────────────────────────

render_main() {
  emit_prompt
  yq -r '.menus | keys[]' "$MENU_FILE" | while read -r key; do
    label="$(yq -r ".menus.$key.label" "$MENU_FILE")"
    emit_item "$label" "$key"
  done
}

render_submenu() {
  local menu="$1"
  emit_prompt

  yq -r ".menus.$menu.items | keys[]" "$MENU_FILE" | while read -r item; do
    label="$(yq -r ".menus.$menu.items.$item.label" "$MENU_FILE")"
    emit_item "$label" "$menu/$item"
  done

  emit_item "⬅ Back" "$(parent_state)"
}

execute_leaf() {
  local menu="$1"
  local item="$2"
  cmd="$(yq -r ".menus.$menu.items.$item.command" "$MENU_FILE")"
  eval "$cmd"
}

# ─────────────────────────────
# State machine
# ─────────────────────────────

case "$STATE" in
  main)
    render_main
    ;;
  */*)
    execute_leaf "${STATE%/*}" "${STATE##*/}"
    exit 0
    ;;
  *)
    render_submenu "$STATE"
    ;;
esac
