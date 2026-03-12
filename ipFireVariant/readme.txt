#here is how to get it installed as a service

chmod 700 the bash sh files

chmod 755 /etc/init.d/syslog-email.service

chkconfig --add syslog-email.service
chkconfig syslog-email-service on

start it----
/etc/init.d/syslog-email.service start



