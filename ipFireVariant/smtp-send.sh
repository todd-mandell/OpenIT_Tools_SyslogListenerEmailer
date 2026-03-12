#!/bin/bash

SUBJECT="$1"
BODY="$2"

SMTP_SERVER="SMTPSERVER"
SMTP_PORT="587"
SMTP_USER="SMTPUSERNAME"
SMTP_PASS="SMTPPASSWORD"

FROM="FROMADDRESS"
TO="TOADDRESS"

{
echo "EHLO HOSTNAME"
echo "AUTH LOGIN"
echo -n "$SMTP_USER" | base64
echo -n "$SMTP_PASS" | base64
echo "MAIL FROM:<$FROM>"
echo "RCPT TO:<$TO>"
echo "DATA"
echo "From: $FROM"
echo "To: $TO"
echo "Subject: $SUBJECT"
echo ""
echo "$BODY"
echo "."
echo "QUIT"
} | openssl s_client -quiet -starttls smtp -connect ${SMTP_SERVER}:${SMTP_PORT} >> /var/log/sysmail.log 2>&1
