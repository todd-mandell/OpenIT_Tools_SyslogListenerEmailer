#here is how to get it installed as a service

chmod 700 the bash sh files

chmod 755 /etc/init.d/syslog-email.service

dont forget the fcron.daily file to gzip the logs every day
chmod 755 /etc/fcron.daily/syslog-email-rotate


start it----
/etc/init.d/syslog-email.service start





