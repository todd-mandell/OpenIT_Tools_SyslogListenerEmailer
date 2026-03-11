#here is how to get it installed as a service

chmod +x /etc/init.d/syslog-email-service

chkconfig --add syslog-email-service

chkconfig syslog-email-service on

/etc/init.d/syslog-email-service start

