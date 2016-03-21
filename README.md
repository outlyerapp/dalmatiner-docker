# Dalmatiner Docker

A container built to play with Dalmatiner DB. Not meant for production use.

Contains: DalmatinerDB, Dalmatiner-FrontEnd, Grafana, Dalmatiner-Grafana-Plugin, Dalmatiner-Graphite, StatsD

Warning! Everything is stored in the container so you should consider any data or dashboards to be ephemeral

### Exposes Ports:

3000  (Grafana Web)

2003  (Graphite Port)

8125  (StatsD Port)

5555  (Dalmatiner TCP)

8080  (Dalmatiner FrontEnd)

To send metrics in configure a StatsD client to connect to localhost:8125. Alternatively, configure collectors with a
Graphite backend to localhost:2003. To view metrics connect to http://localhost:3000 and use admin / admin to login.

If you are running docker-machine you will need to send metrics into your $DOCKER_HOST IP in addition to changing the
Dalmatiner data source in Grafana.

## Getting Started

```
docker run \
  -d \
  -p 3000:3000 \
  -p 2003:2003 \
  -p 8125:8125 \
  -p 5555:5555 \
  -p 8080:8080 \
  --name=dalmatiner-docker \
  dataloop/dalmatiner-docker
```

## Other bits of trivia

There is a setting in ddb.conf that controls how many points are stored in memory before being flushed to disk.

```
cache_points = 10
```

The container has this set to 10 seconds. You may want to increase that if you send a lot of metrics in. Sane defaults are 60 or 600
seconds depending on how many points.

