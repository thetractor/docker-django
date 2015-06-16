#!/bin/bash
set -e

# Make Configurations
${SCRIPTSDIR}/make_configurations.sh

# Run uwsgi
/usr/local/bin/uwsgi --ini ${RUNDIR}/uwsgi.ini
