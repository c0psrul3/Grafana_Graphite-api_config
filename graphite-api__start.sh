#!/usr/bin/env bash

##  reference links:
##  - [https://github.com/brutasse/graphite-api]
##  - [https://graphite-api.readthedocs.io/en/latest/deployment.html]
##  - [http://graphite.readthedocs.io/en/latest/config-local-settings.html]
##  - [http://uwsgi-docs.readthedocs.io/en/latest/tutorials/Django_and_nginx.html#basic-uwsgi-installation-and-configuration]


GRAPHITE_API_YAML="/usr/local/etc/graphite-api.yaml"
GRAPHITE_API_WSGI="/usr/local/etc/graphite-api.wsgi"

GAPI_PORT=8001

UWSGI_DAEMONIZE="--daemonize"



check_graphiteapi_yaml() {

  if [[ ! -f ${GRAPHITE_API_YAML} ]] ; then

    cat <<CONFIG > ${GRAPHITE_API_YAML}
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

  if [[ ! -f ${GRAPHITE_API_YAML} ]] ; then

    cat <<CONFIG > ${GRAPHITE_API_WSGI}
[uwsgi]
processes = 2
http-socket = localhost:8001
plugins = python27
module = graphite_api.app:app
CONFIG

  fi
}


# do start Graphite-API under uWSGI 
GRAPHITE_API_CONFIG=${GRAPHITE_API_YAML} \
  uwsgi --ini ${GRAPHITE_API_WSGI}

  #uwsgi --http :${GAPI_PORT} -w graphite_api.app:app ${UWSGI_OPTS}

