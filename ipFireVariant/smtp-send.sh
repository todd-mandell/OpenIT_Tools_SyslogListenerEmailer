#!/bin/sh

SUBJECT="$1"
BODY="$2"

SMTP_SERVER="SMTPSERVER"
SMTP_PORT="587"
SMTP_USER="SMTPUSERNAME"
SMTP_PASS="SMTPPASSWORD"

FROM="FROMADDRESS"
TO="TOADDRESS"

openssl s_client -starttls smtp -crlf -connect ${SMTP_SERVER}:${SMTP_PORT} <<EOF
EHLO ipfire
AUTH LOGIN
$(printf '%s' "$SMTP_USER" | base64)
$(printf '%s' "$SMTP_PASS" | base64)
MAIL FROM:<$FROM>
RCPT TO:<$TO>
DATA
From: $FROM
To: $TO
Subject: $SUBJECT

$BODY
.
QUIT
EOF
