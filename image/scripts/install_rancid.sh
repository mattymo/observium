#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y subversion expect sendmail openssh-client rancid


cat << EOF > /var/lib/rancid/.cloginrc
add noenable * {1}

# tacacs+ login
add method * ssh
add user * svc-rancid
add password * { rancid_pw } { rancid_pw }
add cyphertype * aes256-ctr
add timeout * 600
EOF

chown -R rancid /var/lib/rancid /var/log/rancid

echo "LIST_OF_GROUPS=\"observium\"" >> /etc/rancid/rancid.conf
sed -i "s|CVSROOT=\$BASEDIR/CVS; export CVSROOT|CVSROOT=\$BASEDIR/SVN; export CVSROOT|" /etc/rancid/rancid.conf
sed -i "s|RCSSYS=cvs; export RCSSYS|RCSSYS=svn; export RCSSYS|" /etc/rancid/rancid.conf
su - rancid /var/lib/rancid/bin/rancid-cvs

echo "\$config['rancid_configs'][]              = \"/var/lib/rancid/observium\";" >> /opt/observium/config.php
echo "\$config['rancid_ignorecomments']        = 0;" >> /opt/observium/config.php
echo "\$config['rancid_version'] = '3';" >> /opt/observium/config.php

echo "0 5 * * * root /rancid_run.sh >> /dev/null 2>&1" >> /etc/crontab
echo "50 23 * * * rancid /usr/bin/find /var/lib/rancid/logs -type f -mtime   +2 -exec rm {} \;" >> /etc/crontab
echo "" >> /etc/crontab
