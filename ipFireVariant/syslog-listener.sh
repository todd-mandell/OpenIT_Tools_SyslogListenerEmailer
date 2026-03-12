#!/bin/sh

LOGFILE="/home/openitmailer/syslog-email-service.log"
SMTP="/home/openitmailer/smtp-send.sh"

PORT1=514
PORT2=162

echo "$(date) Starting syslog listeners on UDP $PORT1 and $PORT2" >> "$LOGFILE"

handle_line() {
    LINE="$1"
    SRCIP="$2"
    TS=$(date +"%Y-%m-%d %H:%M:%S")

    echo "$TS [$SRCIP] $LINE" >> "$LOGFILE"

    SUBJECT="Syslog from $SRCIP at $TS"
    BODY="Source IP: $SRCIP\nMessage: $LINE"

    $SMTP "$SUBJECT" "$BODY"
}

# Listener for port 514
(
    socat -u UDP-RECV:$PORT1,fork SYSTEM:'while read LINE; do SRCIP="$SOCAT_PEERADDR"; /home/openitmailer/syslog-listener-helper.sh "$LINE" "$SRCIP"; done'
) &

# Listener for port 162
(
    socat -u UDP-RECV:$PORT2,fork SYSTEM:'while read LINE; do SRCIP="$SOCAT_PEERADDR"; /home/openitmailer/syslog-listener-helper.sh "$LINE" "$SRCIP"; done'
) &

wait
