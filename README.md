# Dalmatiner Docker

A container built to play with Dalmatiner DB. Not meant for production use.

Contains: DalmatinerDB, Dalmatiner-FrontEnd, Grafana, Dalmatiner-Grafana-Plugin, Dalmatiner-Graphite, StatsD

Exposes Ports:

3000  (Grafana Web)

2003  (Graphite Port)

8125  (StatsD Port)

To send metrics in configure a StatsD client to connect to localhost:8125. Alternatively, configure collectors with a
Graphite backend to localhost:2003. To view metrics connect to http://localhost:3000 and use admin / admin to login.

## Getting Started

```
docker run \
  -d \
  -p 3000:3000 \
  -p 2003:2003 \
  -p 8125:8125 \
  --name=dalmatiner-docker \
  dataloop/dalmatiner-docker
```