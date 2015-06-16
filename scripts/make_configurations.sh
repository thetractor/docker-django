#!/bin/bash
set -e

source "${SCRIPTSDIR}/config.sh"

make_config() {
    echo "Generating uwsgi config file..."
    cat ${UWSGI_CONF_TEMPLATE} \
      | python -c "${PYTHON_JINJA2}" \
      > ${UWSGI_CONF}
}

# generate config files
make_config

exit 0

