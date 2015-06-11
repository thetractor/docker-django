#!/usr/bin/env bash

readonly SUPERVISOR_CONF_TEMPLATE="${CONFDIR}/supervisord.template.conf"
readonly SUPERVISOR_CONF="/etc/supervisor/conf.d/supervisord.conf"

readonly NGINX_CONF_TEMPLATE="${CONFDIR}/nginx.template.conf"
readonly NGINX_CONF="/etc/nginx/conf.d/nginx.conf"

readonly UWSGI_CONF_TEMPLATE="${CONFDIR}/uwsgi.template.ini"
readonly UWSGI_CONF="${RUNDIR}/uwsgi.ini"

readonly PYTHON_JINJA2="import os;
import sys;
import jinja2;
sys.stdout.write(
    jinja2.Template
        (sys.stdin.read()
    ).render(env=os.environ))"
