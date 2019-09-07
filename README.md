# OpenIT_Tools_SyslogListenerEmailer
Listens for syslog on udp 514 and emails each one out. This is for urgent stuff and or field deployments. 


add the text files to C: root folder so that failover listeners can be added and SMTP info can be semi-securely propagated and removed from host system when complete

example files are included in the repo


This program can share smtpinfo and failover lists with the UDP162 listener because it is practically the same code but just for syslog. This one does not do the windows event log bit like the other one does. Unless you send windows event over for 514? but whatever. posted this mainly for my own use. anyone who benefits from it, GREAT! It actually works. 
