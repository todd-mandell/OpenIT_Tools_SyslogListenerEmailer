#!/bin/sh

LOGFILE="/home/openitmailer/syslog-email-service.log"
SMTP="/home/openitmailer/smtp-send.sh"

PORT1=514
PORT2=162

echo "$(date) Starting syslog listeners on UDP $PORT1 and $PORT2" >> "$LOGFILE"

handle_line() {
    LINE="$1"
    TS=$(date +"%Y-%m-%d %H:%M:%S")

    echo "$TS Received: $LINE" >> "$LOGFILE"

    $SMTP "Syslog Alert: $TS" "$LINE"
}

# Listener for port 514 in its own subshell
(
    nc -klu $PORT1 | while read LINE; do
        handle_line "$LINE"
    done
) &

# Listener for port 162 in its own subshell
(
    nc -klu $PORT2 | while read LINE; do
        handle_line "$LINE"
    done
) &

wait
