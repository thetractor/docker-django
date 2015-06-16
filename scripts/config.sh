#!/usr/bin/env bash

readonly UWSGI_CONF_TEMPLATE="${CONFDIR}/uwsgi.template.ini"
readonly UWSGI_CONF="${RUNDIR}/uwsgi.ini"

readonly PYTHON_JINJA2="import os;
import sys;
import jinja2;
sys.stdout.write(
    jinja2.Template
        (sys.stdin.read()
    ).render(env=os.environ))"
