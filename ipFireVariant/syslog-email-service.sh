#!/bin/bash

### CONFIG ###
MAILTO="you@example.com"
MAILFROM="syslog@yourdomain.com"
SMTP_SERVER="smtp.yourprovider.com"
SMTP_PORT="587"
SMTP_USER="YOUR_SMTP_USERNAME"
SMTP_PASS="YOUR_SMTP_PASSWORD"
HOSTNAME=$(hostname)
LOGFILE="/var/log/syslog-email-service.log"

### PURE BASH SMTP (AUTH LOGIN + STARTTLS) ###
smtp_send() {
    local subject="$1"
    local body="$2"

    {
        echo "EHLO ${HOSTNAME}"
        echo "STARTTLS"
        sleep 1
        echo "AUTH LOGIN"
        echo -n "${SMTP_USER}" | base64
        echo -n "${SMTP_PASS}" | base64
        echo "MAIL FROM:<${MAILFROM}>"
        echo "RCPT TO:<${MAILTO}>"
        echo "DATA"
        echo "Subject: ${subject}"
        echo "From: ${MAILFROM}"
        echo "To: ${MAILTO}"
        echo
        echo "${body}"
        echo "."
        echo "QUIT"
    } | openssl s_client -quiet -starttls smtp -connect "${SMTP_SERVER}:${SMTP_PORT}" >>"$LOGFILE" 2>&1
}

### WRAPPER FOR SYSLOG MESSAGES ###
send_mail() {
    local msg="$1"
    echo "$(date) SENDING: $msg" >> "$LOGFILE"
    smtp_send "Syslog (${HOSTNAME})" "$msg"
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
