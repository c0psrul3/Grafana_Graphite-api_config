#!/usr/bin/env bash

##  reference links:
##  - [https://github.com/brutasse/graphite-api]
##  - [https://graphite-api.readthedocs.io/en/latest/deployment.html]
##  - [http://graphite.readthedocs.io/en/latest/config-local-settings.html]
##  - [http://uwsgi-docs.readthedocs.io/en/latest/tutorials/Django_and_nginx.html#basic-uwsgi-installation-and-configuration]


GRAPHITE_API_CONFIG="/usr/local/etc/graphite-api.yaml"
GRAPHITE_API_WSGI="/usr/local/etc/graphite-api.wsgi"

GAPI_PORT=8001

UWSGI_DAEMONIZE="--daemonize"



check_graphiteapi_yaml() {

  if [[ ! -f ${GRAPHITE_API_CONFIG} ]] ; then

    cat <<CONFIG > ${GRAPHITE_API_CONFIG}
---
## [https://graphite-api.readthedocs.io/en/latest/configuration.html#default-values]
search_index: /opt/graphite/index
finders:
  - graphite_api.finders.whisper.WhisperFinder
functions:
  - graphite_api.functions.SeriesFunctions
  - graphite_api.functions.PieFunctions
whisper:
  directories:
    - /opt/graphite/carbon/whisper
time_zone: UTC
CONFIG

  fi
}


check_uwsgi_ini() {

  ## virtualenv's need this:
  #home = /var/www/wsgi-scripts/env

  if [[ ! -f ${GRAPHITE_API_CONFIG} ]] ; then

    cat <<CONFIG > ${GRAPHITE_API_WSGI}
[uwsgi]
processes = 2
http-socket = localhost:8001
uid = 165
gid = 165
module = graphite_api.app:app
daemonize2 = /var/log/uwsgi-graphiteapi.log
env = GRAPHITE_API_CONFIG=${GRAPHITE_API_CONFIG}
CONFIG

  fi
}


# do start Graphite-API under uWSGI 
uwsgi --ini ${GRAPHITE_API_WSGI}

