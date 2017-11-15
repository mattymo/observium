#!/bin/bash -e

apt-get update
apt-get install -y libapache2-mod-fcgid smokeping sendmail
touch /etc/smokeping/config.d/Targets

# Enable smokeping in apache
a2enconf smokeping
a2enmod cgid

cat << EOF > /opt/observium/scripts/reload-smokeping.php
php /opt/observium/scripts/generate-smokeping.php > /etc/smokeping/config.d/Targets
smokeping --reload
EOF

chmod +x /opt/observium/scripts/reload-smokeping.php

echo "10 * * * * root /opt/observium/scripts/reoad-smokeping.php 2>/dev/null" >> /etc/crontab
echo "" >> /etc/crontab
