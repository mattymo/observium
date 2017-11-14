#!/bin/bash -e

yum -y -q install mod_fcgid.x86_64 smokeping
cat << EOF > /etc/smokeping/config
*** General ***

owner    = Super User
contact  = root@localhost
mailhost = my.mail.host
sendmail = /usr/sbin/sendmail
# NOTE: do not put the Image Cache below cgi-bin
# since all files under cgi-bin will be executed ... this is not
# good for images.
imgcache = /var/lib/smokeping/images
imgurl   = /smokeping/images
datadir  = /var/lib/smokeping/rrd
piddir   = /var/run/smokeping
cgiurl   = http://localhost/smokeping/sm.cgi
smokemail = /etc/smokeping/smokemail
tmail     = /etc/smokeping/tmail
#syslogfacility = local0

*** Alerts ***
to = root@localhost
from = root@localhost

+someloss
type = loss
# in percent
pattern = >0%,*12*,>0%,*12*,>0%
comment = loss 3 times  in a row

*** Database ***

step     = 300
pings    = 20

# consfn mrhb steps total

AVERAGE  0.5   1  1008
AVERAGE  0.5  12  4320
    MIN  0.5  12  4320
    MAX  0.5  12  4320
AVERAGE  0.5 144   720
    MAX  0.5 144   720
    MIN  0.5 144   720

*** Presentation ***

template = /etc/smokeping/basepage.html

+ charts

menu = Charts
title = The most interesting destinations

++ stddev
sorter = StdDev(entries=>4)
title = Top Standard Deviation
menu = Std Deviation
format = Standard Deviation %f

++ max
sorter = Max(entries=>5)
title = Top Max Roundtrip Time
menu = by Max
format = Max Roundtrip Time %f seconds

++ loss
sorter = Loss(entries=>5)
title = Top Packet Loss
menu = Loss
format = Packets Lost %f

++ median
sorter = Median(entries=>5)
title = Top Median Roundtrip Time
menu = by Median
format = Median RTT %f seconds

+ overview

width = 600
height = 50
range = 10h

+ detail

width = 600
height = 200
unison_tolerance = 2

"Last 3 Hours"    3h
"Last 30 Hours"   30h
"Last 10 Days"    10d
"Last 400 Days"   400d

*** Probes ***

+ FPing

binary = /usr/sbin/fping

@include /etc/smokeping/Targets
EOF

touch /etc/smokeping/Targets

cat << EOF > /etc/httpd/conf.d/smokeping.conf
<Location /smokeping/smokeping.cgi>
 SetHandler fcgid-script
</Location>
EOF

echo "10 * * * * root php /opt/observium/scripts/generate-smokeping.php > /etc/smokeping/Targets 2>/dev/null" >> /etc/crontab
echo "" >> /etc/crontab
