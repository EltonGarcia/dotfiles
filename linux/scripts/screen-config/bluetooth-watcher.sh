#!/usr/bin/env bash
set -euo pipefail

# ---------- CONFIG ----------
MAC="FD:08:0F:85:01:3A"
DEV_PATH="/org/bluez/hci0/dev_AA_BB_CC_DD_EE_FF"

DELAY=2          # seconds to confirm state change
COOLDOWN=8       # seconds between triggers
#STATE_FILE="$HOME/.cache/k860-bt-last-trigger"
#CONN_STATE_FILE="$HOME/.cache/k860-bt-conn-state"
#ACTION="$HOME/bin/toggle-dell-input.sh"

STATE_FILE="k860-bt-state"
CONN_STATE_FILE="k860-bt-conn-state"
ACTION="./toggle-dell-input.sh"
# ----------------------------

# path from `busctl tree org.bluez`
DEV_PATH="/org/bluez/hci0/dev_$(echo $MAC | tr ':' '_')"

#mkdir -p "$(dirname "$STATE_FILE")"
touch "$STATE_FILE" "$CONN_STATE_FILE"

now() { date +%s; }

last_trigger() {
  [[ -s "$STATE_FILE" ]] && cat "$STATE_FILE" || echo 0
}

update_trigger() {
  echo "$(now)" > "$STATE_FILE"
}

cooldown_ok() {
  (( $(now) - $(last_trigger) > COOLDOWN ))
}

is_connected() {
  busctl get-property org.bluez "$DEV_PATH" \
    org.bluez.Device1 Connected 2>/dev/null | grep -q true
}

remember_state() {
  echo "$1" > "$CONN_STATE_FILE"
}

previous_state() {
  [[ -s "$CONN_STATE_FILE" ]] && cat "$CONN_STATE_FILE" || echo "unknown"
}

handle_state_change() {
  local new="$1"
  local old
  old="$(previous_state)"

  [[ "$new" == "$old" ]] && return
  cooldown_ok || return

  update_trigger
  remember_state "$new"
  "$ACTION"
}

# Initialize remembered state
if is_connected; then
  remember_state "connected"
else
  remember_state "disconnected"
fi

# ---- D-Bus watcher ----
dbus-monitor --system "sender='org.bluez'" |
while read -r line; do
  if echo "$line" | grep -q "Connected"; then
    sleep "$DELAY"

    if is_connected; then
      handle_state_change "connected"
    else
      handle_state_change "disconnected"
    fi
  fi
done
