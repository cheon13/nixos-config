#!/usr/bin/env bash
set -euo pipefail

MODEL="${WHISPER_MODEL:-$HOME/.local/share/whisper/ggml-small.bin}"
PIDFILE="/tmp/dictation.pid"
TMP_WAV="$(mktemp --suffix=.wav)"
TMP_DIR="$(mktemp -d)"

cleanup() {
    rm -rf "$TMP_WAV" "$TMP_DIR"
}
trap cleanup EXIT

notify() {
    command -v notify-send &>/dev/null && notify-send "Dictée" "$1"
}

record_and_transcribe() {
    notify "Enregistrement en cours…"

    pw-record --rate=16000 --channels=1 --format=s16 "$TMP_WAV" &
    REC_PID=$!
    echo "$REC_PID" > "$PIDFILE"

    # Attend que pw-record soit interrompu (par le toggle, voir plus bas)
    wait "$REC_PID" 2>/dev/null || true
    rm -f "$PIDFILE"

    notify "Transcription en cours…"

    whisper-cli \
        -m "$MODEL" \
        -f "$TMP_WAV" \
        -l fr \
        -nt \
        --output-txt \
        --output-file "$TMP_DIR/result" \
        --no-prints \
        > /dev/null 2>&1

    TEXT="$(cat "$TMP_DIR/result.txt" 2>/dev/null | sed '/^\s*$/d')"

    if [[ -z "$TEXT" ]]; then
        notify "Aucun texte détecté."
        exit 1
    fi

    printf '%s' "$TEXT" | wl-copy
    notify "Texte copié dans le presse-papier ✓"
}

record_and_transcribe
