#!/usr/bin/env bash

# Include configuration bootstrap scripts
source "${SCRIPTSDIR}/make_configurations.sh"

run_dev(){
    echo "Running Development Server..."
    export DJDEBUG=1
    python ${APPDIR}/${MANAGEFILE} runserver 0.0.0.0:${PORT}
}

run_worker(){
    echo "Running Worker (Celery)..."
    celery worker \
        --uid=www-data \
        --gid=www-data \
        --app=${CELERYAPP} \
        --loglevel=${CELERYWORKER_LOGLEVEL}
}

run_django_tests(){
    echo "Running Django Tests..."
    python ${APPDIR}/${MANAGEFILE} test
}

run_django_shell(){
    python ${APPDIR}/${MANAGEFILE} shell
}

run_uwsgi(){
    echo "Running App (uWSGI)..."
    make_uwsgi_config
    uwsgi \
        --ini ${RUNDIR}/uwsgi.ini
}
