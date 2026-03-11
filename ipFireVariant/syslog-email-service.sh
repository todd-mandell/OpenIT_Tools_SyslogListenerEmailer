#!/bin/bash

### CONFIG ###
MAILTO="TO"
MAILFROM="FROM"
HOSTNAME=$(hostname)
LOGFILE="/var/log/syslog-email-service.log"

### EMAIL FUNCTION ###
send_mail() {
    local msg="$1"
    {
        echo "From: ${MAILFROM}"
        echo "To: ${MAILTO}"
        echo "Subject: Syslog (${HOSTNAME})"
        echo "Content-Type: text/plain"
        echo
        echo "$msg"
    } | /usr/sbin/sendmail -t

    echo "$(date) SENT: $msg" >> "$LOGFILE"
}

### LISTENER FUNCTION ###
listen_port() {
    local port="$1"
    echo "$(date) Listening on UDP $port" >> "$LOGFILE"

    nc -u -l -p "$port" | while IFS= read -r line; do
        [ -n "$line" ] && send_mail "$line"
    done
}

### RUN BOTH PORTS IN PARALLEL ###
listen_port 514 &
listen_port 162 &

wait
