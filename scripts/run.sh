#!/bin/bash
set -e

# Include configuration bootstrap scripts
source "${SCRIPTSDIR}/make_configurations.sh"

# Run
case "$@" in
    dev)
        echo "Running Development Server..."
        export DJDEBUG=1
        python manage.py runserver 0.0.0.0:${PORT}
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
        /bin/bash
    ;;
    *)
        echo "Running App (uWSGI)..."
        make_uwsgi_config
        uwsgi \
            --ini ${RUNDIR}/uwsgi.ini
    ;;
esac
