#!/usr/bin/env bash
# dictation-toggle.sh
set -euo pipefail

PIDFILE="/tmp/dictation.pid"
SCRIPT="$HOME/.config/dwl/whisper.sh"  # ajuste le chemin

if [[ -f "$PIDFILE" ]]; then
    PID="$(cat "$PIDFILE")"
    if kill -0 "$PID" 2>/dev/null; then
        kill -INT "$PID"
        exit 0
    fi
    rm -f "$PIDFILE"  # PID stale
fi

"$SCRIPT" &
disown
