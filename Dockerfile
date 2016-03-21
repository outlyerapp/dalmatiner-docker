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
EXPOSE 5555

# Install DFE
RUN curl -s -L https://github.com/dataloop/dalmatiner-frontend/releases/download/v0.1.6-b45/dalmatiner-frontend_0.1.6-b45_amd64.deb -o /tmp/dfe.deb && \
    dpkg -i /tmp/dfe.deb &&\
    rm /tmp/dfe.deb
ADD etc/dfe/dfe.conf /etc/dfe/dfe.conf
RUN mkdir /etc/service/dfe
ADD dfe.run /etc/service/dfe/run
EXPOSE 8080

# Install Apt Packages
RUN apt-get update && \
    apt-get -y --no-install-recommends install build-essential libfontconfig ca-certificates python-pip npm git && \
    apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Install Grafana
RUN curl -s https://grafanarel.s3.amazonaws.com/builds/grafana_2.6.0_amd64.deb -o /tmp/grafana.deb && \
    dpkg -i /tmp/grafana.deb && \
    rm /tmp/grafana.deb && \
    curl -s -L https://github.com/dataloop/dalmatiner-grafana-plugin/releases/download/15/dalmatiner-grafana-plugin_15_amd64.deb -o /tmp/grafana-plugin.deb && \
    dpkg -i /tmp/grafana-plugin.deb && \
    rm /tmp/grafana-plugin.deb && \
    curl -s -L https://github.com/tianon/gosu/releases/download/1.7/gosu-amd64 -o /usr/sbin/gosu && \
    chmod +x /usr/sbin/gosu
RUN mkdir /etc/service/grafana
ADD grafana.run /etc/service/grafana/run
EXPOSE 3000

# Install Dalmatiner-Graphite
RUN pip install ddbgraphite==0.0.8
RUN mkdir /etc/service/ddbgraphite
ADD ddbgraphite.run /etc/service/ddbgraphite/run
EXPOSE 2003

# Install StatsD
RUN curl -s -L https://github.com/etsy/statsd/archive/v0.7.2.tar.gz -o /statsd.tgz && \
    mkdir /statsd && \
    tar xfz statsd.tgz -C /statsd --strip-components 1 && \
    rm /statsd.tgz && \
    cd /statsd && npm install && \
    mkdir /etc/statsd
ADD etc/statsd/config.js /etc/statsd/config.js
RUN mkdir /etc/service/statsd
ADD statsd.run /etc/service/statsd/run
EXPOSE 8125

