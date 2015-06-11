#!/bin/bash
set -e

source "${SCRIPTSDIR}/config.sh"

make_config() {
    echo "Generating supervisord config file..."
    cat ${SUPERVISOR_CONF_TEMPLATE} \
      | python -c "${PYTHON_JINJA2}" \
      > ${SUPERVISOR_CONF}

    echo "Generating nginx config file..."
    cat ${NGINX_CONF_TEMPLATE} \
      | python -c "${PYTHON_JINJA2}" \
      > ${NGINX_CONF}

    echo "Generating uwsgi config file..."
    cat ${UWSGI_CONF_TEMPLATE} \
      | python -c "${PYTHON_JINJA2}" \
      > ${UWSGI_CONF}
}

# generate config files
make_config

exit 0

