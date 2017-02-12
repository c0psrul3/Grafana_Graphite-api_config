[uwsgi]
processes = 2
http-socket = localhost:8001
uid = 165
gid = 165
module = graphite_api.app:app
daemonize2 = /var/log/uwsgi-graphiteapi.log
env = GRAPHITE_API_CONFIG=/usr/local/etc/graphite-api.yaml
