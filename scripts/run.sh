#!/bin/bash
set -e

# Make Configurations
${SCRIPTSDIR}/make_configurations.sh

# Run
case "$@" in
    app)
        echo "Running App (uWSGI)..."
        uwsgi \
            --ini ${RUNDIR}/uwsgi.ini
    ;;
    worker)
        echo "Running Worker (Celery)..."
        celery worker \
            --uid=www-data \
            --gid=www-data \
            --app=${CELERYAPP} \
            --loglevel=${CELERYWORKER_LOGLEVEL}
    ;;
    shell)
        exec "/bin/bash"
    ;;
esac
