#!/bin/sh

LINE="$1"
SRCIP="$2"

LOGFILE="/home/openitmailer/syslog-email-service.log"
SMTP="/home/openitmailer/smtp-send.sh"

TS=$(date +"%Y-%m-%d %H:%M:%S")

echo "$TS [$SRCIP] $LINE" >> "$LOGFILE"

SUBJECT="Syslog from $SRCIP at $TS"
BODY="Source IP: $SRCIP\nMessage: $LINE"

$SMTP "$SUBJECT" "$BODY"
