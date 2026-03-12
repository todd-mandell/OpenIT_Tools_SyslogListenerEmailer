#!/bin/bash

LOGFILE="/home/openitmailer/syslog-email-service.log"

PORT1=514
PORT2=162

echo "$(date) Starting syslog listeners on UDP $PORT1 and $PORT2" >> "$LOGFILE"

handle_line() {
    local LINE="$1"
    local TS
    TS=$(date +"%Y-%m-%d %H:%M:%S")

    echo "$TS Received: $LINE" >> "$LOGFILE"

    /home/openitmailer/smtp-send.sh "Syslog Alert: $TS" "$LINE"
}

# Listener for port 514
nc -klu $PORT1 | while read -r LINE; do
    handle_line "$LINE"
done &

# Listener for port 162
nc -klu $PORT2 | while read -r LINE; do
    handle_line "$LINE"
done &

wait
