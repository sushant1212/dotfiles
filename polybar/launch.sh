#!/usr/bin/env bash
#
# polybar launcher for i3 -- safe to call from `exec_always`, which fires on
# every i3 reload/restart. Kills any running polybar, waits for the processes
# to actually die (rather than racing them), then starts exactly one bar.

set -u

BAR="${1:-main}"
CONFIG="$HOME/.config/polybar/config.ini"

# Ask nicely first.
pkill -u "$UID" -x polybar >/dev/null 2>&1

# Wait for death, up to ~5s, instead of assuming it was instant.
for _ in $(seq 1 50); do
  pgrep -u "$UID" -x polybar >/dev/null 2>&1 || break
  sleep 0.1
done

# Anything still alive after the grace period gets SIGKILL.
if pgrep -u "$UID" -x polybar >/dev/null 2>&1; then
  pkill -u "$UID" -9 -x polybar >/dev/null 2>&1
  sleep 0.3
fi

# Give the X server a moment to release the system-tray selection. Tray clients
# (nm-applet, blueman) are embedded in the old bar, and starting the new bar
# before that ownership is released makes it fail to embed them and exit.
sleep 0.5

# Stale IPC sockets from a killed bar would otherwise linger.
rm -f /tmp/polybar_mqueue.* 2>/dev/null

mkdir -p "$HOME/.cache"
polybar --reload --config="$CONFIG" "$BAR" \
  >>"$HOME/.cache/polybar-$BAR.log" 2>&1 &

disown
