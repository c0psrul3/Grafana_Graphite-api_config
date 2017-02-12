[uwsgi]
processes = 2
http-socket = localhost:8001
plugins = python27
module = graphite_api.app:app
