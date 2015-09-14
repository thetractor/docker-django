#!/usr/bin/env bash
set -e

# Include
source "${SCRIPTSDIR}/docker-python-commands.sh"
source "${SCRIPTSDIR}/docker-django-commands.sh"

# Define help message
show_help() {
    echo """
Usage: docker run <imagename> COMMAND

Commands

dev      : Start a normal Django development server. Optionally provide the 'PORT' env
           variable to determine the port on which it listens.
worker   : Start a celery worker. Requires the env variables 'CELERYAPP' and
           'CELERYWORKER_LOGLEVEL'
bash     : Start a bash shell
test     : Run the Django tests. Optionally provide custom 'MANAGEFILE'.
tox      : Run the Tox tests. Requires 'TOXFILEDIR' and tox to be installed
shell    : Start a Django Python shell. Optionally provide custom 'MANAGEFILE'.
uwsgi    : Run uwsgi server. Requires the env variables 'DJANGOROOT', 'WSGIFILE' and
           'DJANGO_SETTINGS_MODULE'. Optional env variables are 'PORT',
           'UWSGIPORT' and 'STATUSPORT'.
python   : Run a classic python shell
ptpython : Run a ptpython shell
help     : Show this message
"""
}

# Run
case "$1" in
    dev)
        run_dev "${@:2}"
    ;;
    worker)
        run_worker "${@:2}"
    ;;
    bash)
        run_bash "${@:2}"
    ;;
    test)
        run_django_tests "${@:2}"
    ;;
    tox)
        run_tox "${@:2}"
    ;;
    shell)
        run_django_shell "${@:2}"
    ;;
    uwsgi)
        run_uwsgi "${@:2}"
    ;;
    python)
        run_python "${@:2}"
    ;;
    ptpython)
        run_ptpython "${@:2}"
    ;;
    help)
        show_help
    ;;
    *)
        show_help
    ;;
esac
