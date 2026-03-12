#!/bin/sh

LOGFILE="/home/openitmailer/syslog-email-service.log"
SMTP="/home/openitmailer/smtp-send.sh"

log() {
    TS=$(date +"%Y-%m-%d %H:%M:%S")
    echo "$TS $*" >> "$LOGFILE"
}

send_email() {
    PORT="$1"
    SRCIP="$2"
    MSG="$3"

    TS=$(date +"%Y-%m-%d %H:%M:%S")
    SUBJECT="Syslog datagram from $SRCIP on UDP $PORT at $TS"
    BODY=$(printf "Source IP: %s\nPort: %s\n\n%s\n" "$SRCIP" "$PORT" "$MSG")

    "$SMTP" "$SUBJECT" "$BODY"
}

listener() {
    PORT="$1"
    ERRFILE="/home/openitmailer/nc${PORT}.err"

    log "Starting nc on UDP $PORT"

    nc -v -klu "$PORT" 2>"$ERRFILE" | while IFS= read -r DATAGRAM; do
        # Extract sender IP from nc stderr
        SRCIP=$(grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' "$ERRFILE" | tail -n1)
        SRCIP=${SRCIP:-unknown}

        log "Received datagram from $SRCIP on $PORT"

        # Send entire datagram as one email
        send_email "$PORT" "$SRCIP" "$DATAGRAM"
    done &
}

log "=== syslog-listener.sh starting ==="

listener 514
listener 162

wait
