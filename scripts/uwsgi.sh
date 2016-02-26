#!/usr/bin/env bash

readonly UWSGI_CONF_TEMPLATE="${CONF_DIR}/uwsgi.template.ini"
readonly UWSGI_CONF="${RUN_DIR}/uwsgi.ini"

readonly PYTHON_JINJA2="import os;
import sys;
import jinja2;
sys.stdout.write(
    jinja2.Template
        (sys.stdin.read()
    ).render(env=os.environ))"

make_uwsgi_config() {
    echo "Generating uwsgi config file..."
    cat ${UWSGI_CONF_TEMPLATE} \
      | python -c "${PYTHON_JINJA2}" \
      > ${UWSGI_CONF}
}

if [ -f ${DJANGO_ROOT}/${WSGI_FILE} ];
then
    echo "Running App (uWSGI)..."
    make_uwsgi_config
    uwsgi --ini ${UWSGI_CONF} "$@"
else
    echo "Cannot start uwsgi: missing ${DJANGO_ROOT}/${WSGI_FILE}"
fi
