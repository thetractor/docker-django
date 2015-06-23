#!/bin/bash

source "${SCRIPTSDIR}/config.sh"

make_uwsgi_config() {
    echo "Generating uwsgi config file..."
    cat ${UWSGI_CONF_TEMPLATE} \
      | python -c "${PYTHON_JINJA2}" \
      > ${UWSGI_CONF}
}
