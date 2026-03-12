#!/bin/sh

LOGFILE="/home/openitmailer/syslog-email-service.log"
SMTP="/home/openitmailer/smtp-send.sh"

BUFFER=""
LAST_SRCIP=""
LAST_TIME=0

flush_buffer() {
    SRC="$1"
    [ -z "$BUFFER" ] && return

    TS=$(date +"%Y-%m-%d %H:%M:%S")
    SUBJECT="Syslog from $SRC at $TS"
    BODY=$(printf "Source IP: %s\nMessage:\n%s\n" "$SRC" "$BUFFER")

    echo "$TS [$SRC] FLUSHED MESSAGE:" >> "$LOGFILE"
    printf "%s\n" "$BUFFER" >> "$LOGFILE"

    $SMTP "$SUBJECT" "$BODY"

    BUFFER=""
}

listener() {
    PORT="$1"
    ERRFILE="/home/openitmailer/nc${PORT}.err"

    # Run nc in verbose mode, stderr → ERRFILE, stdout → message stream
    nc -v -klu "$PORT" 2>"$ERRFILE" | while read LINE; do

        # Extract sender IP from stderr
        SRCIP=$(grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' "$ERRFILE" | tail -n1)
        SRCIP=${SRCIP:-unknown}

        # If sender changed, flush previous buffer
        if [ "$SRCIP" != "$LAST_SRCIP" ] && [ -n "$BUFFER" ]; then
            flush_buffer "$LAST_SRCIP"
        fi

        LAST_SRCIP="$SRCIP"

        # Append line to buffer
        if [ -z "$BUFFER" ]; then
            BUFFER="$LINE"
        else
            BUFFER="$BUFFER\n$LINE"
        fi

        # Reset flush timer
        LAST_TIME=$(date +%s%3N)
    done &
}

echo "$(date) Starting syslog listeners on UDP 514 and 162" >> "$LOGFILE"

# Start listeners
listener 514
listener 162

# Timer loop: flush after 200ms of inactivity
while true; do
    NOW=$(date +%s%3N)
    if [ -n "$BUFFER" ] && [ $((NOW - LAST_TIME)) -gt 200 ]; then
        flush_buffer "$LAST_SRCIP"
    fi
    sleep 0.1
done
