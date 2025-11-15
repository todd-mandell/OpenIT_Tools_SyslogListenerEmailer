#!/bin/bash
journalctl -f \
  | grep -Ev "DST=224.0.0.1|CRON|systemd|NetworkManager|snapd|apt|avahi|cups|bluetooth" \
  | nc -u #IP OR HOST HERE# 514



###### grep -v starterPAK  #######
# if you use UFW 
#     grep -Ev "DST=224.0.0.1|CRON|systemd|NetworkManager|snapd|apt|avahi|cups|bluetooth"
# if you dont use ufw and you're on iptables, you got this
