#!/usr/bin/env bash

# Include configuration bootstrap scripts
source "${SCRIPTSDIR}/make_configurations.sh"

# Define manage.py name
if [ -z $MANAGEFILE ]; then
    export MANAGEFILE=manage.py
fi

run_dev(){
    echo "Running Development Server..."
    export DJDEBUG=1
    python ${MANAGEFILE} runserver 0.0.0.0:${PORT}
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
    python ${MANAGEFILE} test
}

run_django_shell(){
    python ${MANAGEFILE} shell
}

run_uwsgi(){
    echo "Running App (uWSGI)..."
    make_uwsgi_config
    uwsgi \
        --ini ${RUNDIR}/uwsgi.ini
}
