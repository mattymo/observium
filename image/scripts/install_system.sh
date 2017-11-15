#!/bin/bash

apt-get update
apt-get install -y apache2 composer fping git graphviz imagemagick \
  libapache2-mod-php7.0 mariadb-client mariadb-server mtr-tiny nmap php7.0-cli \
  php7.0-curl php7.0-gd php7.0-json php7.0-mcrypt php7.0-mysql php7.0-snmp \
  php7.0-xml php7.0-zip php7.0-opcache python-memcache python-mysqldb rrdtool \
  snmp snmpd whois ipmitool wget rsyslog cron supervisor

#Disable the default apache config
a2dissite default

mkdir /tmp/php-opcache && chmod 777 /tmp/php-opcache
sed -i 's|;opcache.enable_cli=0|opcache.enable_cli=1|' /etc/php/7.0/cli/php.ini
sed -i 's|;opcache.file_cache=|opcache.file_cache=/tmp/php-opcache|' /etc/php/7.0/cli/php.ini

sed -i 's|#module(load="imudp")|module(load="imudp")|' /etc/rsyslog.conf
echo '$UDPServerRun 514' >> /etc/rsyslog.conf

cat <<EOF > /etc/rsyslog.d/30-observium.conf
#---------------------------------------------------------
#send remote logs to observium

\$template observium,"%fromhost%||%syslogfacility%||%syslogpriority%||%syslogseverity%||%syslogtag%||%\$year%-%\$month%-%\$day% %timereported:8:25%||%msg%||%programname%\n"
\$ModLoad omprog
\$ActionOMProgBinary /opt/observium/syslog.php

:inputname, isequal, "imudp" :omprog:;observium

& ~
# & stop
#---------------------------------------------------------
EOF
