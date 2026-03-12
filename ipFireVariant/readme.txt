#here is how to get it installed as a service

chmod 700 the bash sh files

systemctl daemon-reload
systemctl enable --now syslog-listener.service


