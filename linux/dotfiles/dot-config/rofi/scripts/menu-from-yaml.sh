#!/usr/bin/env bash
# Execute
#   rofi -show test \
#     -modi "test:./menu-from-yaml.sh" \
#     -run-command '{cmd} {info}' \
#     -p "$(yq -r '.title' ./test-menu.yml)"

set -eo pipefail

YAML="$HOME/.config/rofi/scripts/test-menu.yml"
STATE="${ROFI_INFO:-main}"

# ─────────────────────────────
# Helpers
# ─────────────────────────────

title_root() {
  yq -r '.title' "$YAML"
}

breadcrumb() {
  echo "get breadcrumb" >&2
  local path="$1"
  local title
  title="$(title_root)"

  IFS='/' read -ra parts <<< "$path"
  for p in "${parts[@]}"; do
    [[ "$p" == "main" ]] && continue
    label="$(yq -r ".menus.$p.label // empty" "$YAML")"
    [[ -n "$label" ]] && title+=" › ${label#* }"
  done

  echo "$title"
}

parent_state() {
  [[ "$STATE" != *"/"* ]] && echo "main" && return
  echo "${STATE%/*}"
}

emit() {
  # display\0info\x1fstate\n
  printf "%s\0info\x1f%s\n" "$1" "$2"
}

# ─────────────────────────────
# Menu rendering
# ─────────────────────────────

render_main() {
  yq -r '.menus | keys[]' "$YAML" | while read -r key; do
    label="$(yq -r ".menus.$key.label" "$YAML")"
    emit "$label" "$key"
  done
}

render_submenu() {
  local menu="$1"

  yq -r ".menus.$menu.items | keys[]" "$YAML" | while read -r item; do
    label="$(yq -r ".menus.$menu.items.$item.label" "$YAML")"
    emit "$label" "$menu/$item"
  done

  emit "⬅ Back" "back"
}

# ─────────────────────────────
# Execution
# ─────────────────────────────

echo "STATE=$STATE INFO=$ROFI_INFO RETV=$ROFI_RETV 1=$1 2=$2" >&2

case "$STATE" in
  main)
    render_main
    ;;
  back)
    render_main
    ;;
  */*)
    # Leaf node → execute command
    menu="${STATE%/*}"
    item="${STATE##*/}"
    cmd="$(yq -r ".menus.$menu.items.$item.command" "$YAML")"
    eval "$cmd"
    exit 0
    ;;
  *)
    # Submenu
    render_submenu "$STATE"
    ;;
esac
