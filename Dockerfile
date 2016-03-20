# Use phusion/baseimage as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
# a list of version numbers.
FROM phusion/baseimage:latest

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]


# Install DDB
RUN curl -s -L https://github.com/dataloop/dalmatinerdb/releases/download/v0.1.6-b160/dalmatinerdb_0.1.6-b160_amd64.deb -o /tmp/ddb.deb && \
    dpkg -i /tmp/ddb.deb &&\
    rm /tmp/ddb.deb


# Install DFE
RUN curl -s -L https://github.com/dataloop/dalmatiner-frontend/releases/download/v0.1.6-b45/dalmatiner-frontend_0.1.6-b45_amd64.deb -o /tmp/dfe.deb && \
    dpkg -i /tmp/dfe.deb &&\
    rm /tmp/dfe.deb


# Install Grafana

RUN apt-get update && \
    apt-get -y --no-install-recommends install libfontconfig ca-certificates && \
    apt-get clean && \
    curl -s https://grafanarel.s3.amazonaws.com/builds/grafana_2.6.0_amd64.deb -o /tmp/grafana.deb && \
    dpkg -i /tmp/grafana.deb && \
    rm /tmp/grafana.deb && \
    curl -s -L https://github.com/tianon/gosu/releases/download/1.7/gosu-amd64 -o /usr/sbin/gosu && \
    chmod +x /usr/sbin/gosu && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

VOLUME ["/var/lib/grafana", "/var/log/grafana", "/etc/grafana"]

EXPOSE 3000


# Disable some phusion base services
# RUN touch /etc/service/{cron,sshd,syslog-ng,syslog-forwarder}/down
RUN touch /etc/service/{cron, syslog-ng}/down
