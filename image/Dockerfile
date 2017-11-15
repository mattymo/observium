FROM phusion/baseimage:0.9.22
MAINTAINER Matthew Mosesohn <matthew.mosesohn@virtustream.com>

# Set install method (community or pro)
ENV INSTALL_METHOD community

# Required for pro install method
ENV SVN_REPO http://svn.observium.org/svn/observium/branches/stable
ENV SVN_DEST /opt/observium
ENV SVN_USER svn_user
ENV SVN_PASS svn_pass

ENV MYSQL_HOST observ_db
ENV MYSQL_DATABASE observium
ENV MYSQL_USER observium
ENV MYSQL_PASSWORD changeme

ENV DOMAIN serv.example.com

ENV ADMIN_USER admin
ENV ADMIN_PASSWORD changeme
ENV ADMIN_EMAIL admin@example.com

ENV SNMP_COMM=public
ENV SNMP_LOC=Rack,\ Room,\ Building,\ City,\ Country\ \[GPSX,Y\]
ENV SNMP_CON=Your\ Name\ \<your@email.address\>

#Set to no if deploying with helm
ENV GENERATE_CONFIG yes

# Language specifics
ENV LC_ALL C
ENV LC_NUMERIC C
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

COPY scripts/install_system.sh /tmp
RUN /tmp/install_system.sh

COPY scripts/install_observium_community.sh /tmp
COPY scripts/install_observium_pro.sh /tmp
RUN /tmp/install_observium_${INSTALL_METHOD}.sh

COPY virtustream_logo.png /opt/observium/html/images/virtustream_logo.png
COPY scripts/install_rancid.sh /tmp
RUN /tmp/install_rancid.sh
COPY scripts/install_smokeping.sh /tmp
RUN /tmp/install_smokeping.sh

COPY scripts/rancid_run.sh /
COPY scripts/update.sh /
COPY scripts/start.sh /

COPY configs/supervisord.conf /etc/supervisor/supervisord.conf
COPY configs/supervisor.d/ /etc/supervisor/conf.d/

RUN chmod 600 /etc/supervisor/supervisord.conf /etc/supervisor/conf.d/*.conf

WORKDIR /opt/observium

VOLUME ["/opt/observium/rrd"]
VOLUME ["/opt/observium/logs"]
VOLUME ["/opt/observium/html"]
VOLUME ["/opt/observium/mibs"]
VOLUME ["/opt/observium/scripts"]
VOLUME ["/var/lib/rancid"]
VOLUME ["/var/lib/smokeping"]

EXPOSE 80
EXPOSE 514/udp
EXPOSE 161/udp

ENTRYPOINT ["/start.sh"]
CMD ["/usr/bin/supervisord"]
