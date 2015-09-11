# Docker Django Web Stack

Base image for creating a Docker image running Django in a uWSGI container

This builds multiple versions of the image that are tagged based on the Python
version used.

## Usage

This image is mainly used to simplify a number of tasks that are common across
Django projects:
 - Configure uWSGI
 - Run uWSGI
 - Expose ports
 - Wrapper for various commonly called commands

To start using the image, just inherit from it in your project's Dockerfile:

    FROM vikingco/django:3.4

This will give you `python`, `pip` `ipython`, `ptpython`, `git` and `uwsgi`.
Everything else you will need to install yourself by adding extra `RUN`
commands to your project's Dockerfile.

You will probably still need the following lines

    COPY deployment/requirements.txt ${DEPLOYMENTDIR}/requirements.txt
    RUN pip install -r ${DEPLOYMENTDIR}/requirements.txt
    COPY . ${SRCDIR}


### docker-entrypoint.sh

This is the main entrypoint of the image. It is built to comply with the [best
practices](https://docs.docker.com/articles/dockerfile_best-practices/#entrypoint).
`docker-entrypoint.sh` takes a command as argument, which are listed below. Some of them are configurable by environment variables.

#### dev
Starts a Django development server.

Env variable | Required | Description
--- | --- | ---
APPDIR | No | Directory where the `manage.py` file is if not the root directory
DJANGO_SETTINGS_MODULE | Yes | Name of the settings module
MANAGEFILE | No | Provide name of `manage.py` if it differs from `manage.py`
PORT | No | Provide the port on which the Django server should listen. Defaults to 8000

#### worker
Start a celery worker. Requires Celery to be installed in the project's Dockerfile.

Env variable | Required | Description
--- | --- | ---
CELERYAPP | Yes | Provided to Celery's `--app` argument
CELERYWORKER_LOGLEVEL | Yes | The loglevel of Celery workers

#### bash
Starts a bash shell

#### test
Runs the standard Django tests

Env variable | Required | Description
--- | --- | ---
APPDIR | No | Directory where the `manage.py` file is if not the root directory
MANAGEFILE | No | Provide name of `manage.py` if it differs from `manage.py`

#### tox
Runs tox tests

Env variable | Required | Description
--- | --- | ---
TOXFILEDIR | No | Specify name of directory where the `tox.ini` file exists if it differs from `./`

##### advanced topics

*   build dependencies:

    Since running tox will create new virtual environments, in most cases it is required to have additional system
    packages available. A straightforward example would be `libpg-dev` which is required if you are installing psycopg2.

    Those 'build dependencies' can be provided via the `builddeps.txt` file, that can be added in the `deployment`
    directory.

    **WARNING: These build dependencies will be installed before running tox, and uninstalled afterwards. Make sure that
    your application does not depend on these build dependencies directly!**

    Env variable | Required | Description
    --- | --- | ---
    BUILDDEPSFILE | No | Provide name of `builddeps.txt` if it differs from `builddeps.txt`


#### shell
Run a Django Python shell

Env variable | Required | Description
--- | --- | ---
APPDIR | No | Directory where the `manage.py` file is if not the root directory
MANAGEFILE | No | Provide name of `manage.py` if it differs from `manage.py`

#### uwsgi
Run the app using uWSGI

Env variable | Required | Description
--- | --- | ---
APPDIR | No | Directory where the `manage.py` file is if not the root directory
WSGIFILE | Yes | Provide name of `wsgi.py` relative to the root src directory
DJANGO_SETTINGS_MODULE | Yes | Name of the settings module
PORT | No | Port on which uWSGI will listen for HTTP connections. Defaults to 8000
UWSGIPORT | No | Port on which uWSGI server will listen (use together with Nginx). Defaults to 3031
STATUSPORT | No | Port on which uWSGI will server status information. Defaults to 9191

#### python
Start a Python shell

#### help
Show a help message
