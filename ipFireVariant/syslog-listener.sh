#!/bin/bash

PORT=514
LOGFILE="/var/log/syslog-email-service.log"

echo "Starting syslog listener on UDP $PORT" >> "$LOGFILE"

# Create UDP socket listener
nc -klu $PORT | while read -r LINE; do
    TS=$(date +"%Y-%m-%d %H:%M:%S")
    echo "$TS Received: $LINE" >> "$LOGFILE"

    # Send email for each syslog line
    /usr/local/bin/smtp-send "Syslog Alert: $TS" "$LINE"
done
