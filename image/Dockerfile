# Version: 17.9.0
FROM centos:7
MAINTAINER Raenko Ivan <admin@sysadminsk.ru>

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

#RUN localedef -i ru_RU -f UTF-8 ru_RU.UTF-8 && \
#  cp -f /usr/share/zoneinfo/Asia/Novosibirsk /etc/localtime
#
#ENV LANG ru_RU.utf8

# Language specifics
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Install locales by reinstalling glibc-common
RUN yum reinstall -y glibc-common

COPY scripts/install_system.sh /tmp
RUN /tmp/install_system.sh

COPY scripts/install_observium_community.sh /tmp
COPY scripts/install_observium_pro.sh /tmp
RUN /tmp/install_observium_${INSTALL_METHOD}.sh

COPY virtustream_logo.png /opt/observium/html/images/virtustream_logo.png
COPY scripts/install_rancid.sh /tmp
RUN /tmp/install_rancid.sh

COPY scripts/rancid_run.sh /
COPY scripts/update.sh /
COPY scripts/start.sh /

COPY configs/supervisord.conf /etc/supervisord.conf
COPY configs/supervisor.d/ /etc/supervisord.d/
RUN chmod 600 /etc/supervisord.conf /etc/supervisord.d/*.ini

WORKDIR /opt/observium

VOLUME ["/opt/observium/rrd"]
VOLUME ["/opt/observium/logs"]
VOLUME ["/opt/observium/html"]
VOLUME ["/opt/observium/mibs"]
VOLUME ["/opt/observium/scripts"]
VOLUME ["/home/rancid/.ssh"]
VOLUME ["/usr/local/rancid/var"]

EXPOSE 80
EXPOSE 514/udp
EXPOSE 161/udp

ENTRYPOINT ["/start.sh"]
CMD ["/usr/bin/supervisord"]
