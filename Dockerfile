FROM phusion/baseimage:latest

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Install DDB
RUN curl -s -L https://github.com/dataloop/dalmatinerdb/releases/download/v0.1.6-b160/dalmatinerdb_0.1.6-b160_amd64.deb -o /tmp/ddb.deb && \
    dpkg -i /tmp/ddb.deb &&\
    rm /tmp/ddb.deb && \
    mkdir -p /data/ddb && \
    chown -R dalmatiner. /data/ddb && \
    chown -R dalmatiner. /usr/lib/ddb
ADD etc/ddb/ddb.conf /etc/ddb/ddb.conf
RUN mkdir /etc/service/ddb
ADD ddb.run /etc/service/ddb/run

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

