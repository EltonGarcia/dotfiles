#!/usr/bin/env bash
#
# lima-clip-sync.sh — real-time bi-directional clipboard sync
# between Wayland host and Lima VM.
#
# Requirements:
#   - wl-clipboard (wl-copy, wl-paste) on host
#   - SSH access to VM ("lima" host alias configured)
#   - /tmp writable on VM
#
# Usage:
#   lima-clip-sync.sh start    # run in foreground
#   lima-clip-sync.sh daemon   # run in background (detached)
#   lima-clip-sync.sh stop     # stop running sync daemon
#

set -euo pipefail

SCPT_PID="$$"
VM_DEFAULT="lima-default"
VM_HOST="${VM_HOST:-$VM_DEFAULT}"
REMOTE_CLIP_FILE="/tmp/clipboard.txt"
PID_FILE="${XDG_RUNTIME_DIR:-/tmp}/lima-clip-sync.pid"

# Check dependencies
for cmd in ssh wl-copy wl-paste socat inotifywait; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "❌ Missing dependency: $cmd"
    echo "Please install wl-clipboard, inotify-tools, and socat."
    exit 1
  fi
done

sync_to_vm() {
  wl-paste --watch bash -c "wl-paste -n | ssh $VM_HOST \"cat > '$REMOTE_CLIP_FILE'\""
  #wl-paste --watch bash -c "ssh $VM_HOST \"echo $(wl-paste -n) > '$REMOTE_CLIP_FILE'\""
  #wl-paste --watch bash -c "wl-paste | tee -a to-remote.txt"
}

sync_from_vm() {
  ssh "$VM_HOST" "inotifywait -m -e modify '$REMOTE_CLIP_FILE' --format ''" | while read -r; do
    local newContent=$(ssh "$VM_HOST" "cat '$REMOTE_CLIP_FILE'")
    if [[ "$(wl-paste)" != "$newContent" ]]; then
      echo "$newContent" | wl-copy -n
      echo "📥 VM → host clipboard updated"
    else
      echo "📥 VM → host clipboard ignored"
    fi
  done
}

start_sync() {
  echo "🔄 Starting bi-directional clipboard sync with $VM_HOST PID: $SCPT_PID"
  sync_to_vm &
  PID1=$!
  sync_from_vm &
  PID2=$!
  echo "$PID1 $PID2" > "$PID_FILE"
  echo "✅ Sync running (PID: $PID1, $PID2)"
  sleep 1
  list_descendants "$SCPT_PID"
  ps -s "$SCPT_PID"
  wait
}

stop_sync() {
  if [[ -f "$PID_FILE" ]]; then
    read -r PID1 PID2 < "$PID_FILE" || true
    kill "$PID1" "$PID2" 2>/dev/null || true
    rm -f "$PID_FILE"
    echo "🛑 Clipboard sync stopped."
  else
    echo "No sync daemon running."
  fi
}

list_descendants ()
{
  local children=$(ps -o pid= --ppid "$1")

  for pid in $children
  do
    list_descendants "$pid"
  done

  echo "$children"
}


case "${1:-}" in
  start)  start_sync ;;
  daemon) nohup "$0" start >/dev/null 2>&1 & echo "✅ Sync daemon started." ;;
  stop)   stop_sync ;;
  *)      list_descendants "$SCPT_PID";; #echo "Usage: $0 [start|daemon|stop]" ;;
esac
