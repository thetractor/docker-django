#!/bin/bash
set -e

# Include
source "${SCRIPTSDIR}/docker-python-commands.sh"
source "${SCRIPTSDIR}/docker-django-commands.sh"

# Define help message
show_help() {
    echo """
Usage: docker run <imagename> COMMAND

Commands

dev     : Start a normal Django development server. Provide the 'APPDIR' env
          which specifies the name of the dir that contains the manage.py file.
          Provide 'MANAGEFILE' to be the name of the manage.py file.
          Optionally provide the 'PORT' env
          variable to determine the port on which it listens.
worker  : Start a celery worker. Requires the env variables 'CELERYAPP' and
          'CELERYWORKER_LOGLEVEL'
bash    : Start a bash shell
test    : Run the Django tests. Requires 'APPDIR' and 'MANAGEFILE'
tox     : Run the Tox tests. Requires 'TOXFILEDIR' and tox to be installed
shell   : Start a Django Python shell. Requires 'APPDIR' and 'MANAGEFILE'
uwsgi   : Run uwsgi server. Requires the env variables 'APPDIR', 'WSGIFILE',
          'DJANGO_SETTINGS_MODULE'. Optional env variables are 'PORT',
          'UWSGIPORT' and 'STATUSPORT'.
python  : Run a Python shell
help    : Show this message
"""
}

# Define manage.py name
if [ -z $MANAGEFILE ]; then
    export MANAGEFILE=manage.py
fi

# Run
case "$1" in
    dev)
        run_dev
    ;;
    worker)
        run_worker
    ;;
    bash)
        run_bash
    ;;
    test)
        run_django_tests
    ;;
    tox)
        run_tox
    ;;
    shell)
        run_django_shell
    ;;
    uwsgi)
        run_uwsgi
    ;;
    python)
        run_python
    ;;
    help)
        show_help
    ;;
    *)
        show_help
    ;;
esac
