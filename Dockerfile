###########################################################
# VikingCo: Django Web Stack (Python 3.4)
###########################################################
FROM python:3.4-slim
MAINTAINER Dirk Moors

ENV PYTHONUNBUFFERED 1

ENV CONFDIR /tmp/conf

ENV ROOT /srv/www

ENV APPSRC ./app
ENV DEPLOYMENTSRC ./deployment
ENV CONFSRC ./conf
ENV SCRIPTSSRC ./scripts

ENV APPDIR ${ROOT}/app
ENV DEPLOYMENTDIR ${ROOT}/deployment
ENV MEDIADIR ${ROOT}/media
ENV STATICDIR ${ROOT}/static
ENV LOGDIR ${ROOT}/logs
ENV RUNDIR ${ROOT}/run
ENV SCRIPTSDIR ${ROOT}/scripts

ENV CELERYAPP service.celery:app
ENV CELERYWORKER_LOGLEVEL INFO

ENV PORT 8000
ENV UWSGIPORT 3031
ENV STATUSPORT 9191

ENV DJANGO_REQUIREMENTS_FILE ${DEPLOYMENTDIR}/requirements-production.txt
ENV DJANGO_SETTINGS_MODULE service.settings

# install and configure packages
RUN set -x \
	&& buildDeps=' \
		curl \
		gcc \
		libbz2-dev \
		libc6-dev \
		libncurses-dev \
		libsqlite3-dev \
		libssl-dev \
		make \
		xz-utils \
		zlib1g-dev \
	' \
	&& requiredAptPackages=' \
        sqlite3 \
        nano \
	' \
	&& requiredPipPackages=' \
	    uwsgi \
        Jinja2 \
	' \
	&& apt-get update \
	&& apt-get install -y $buildDeps $requiredAptPackages --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    && pip install $requiredPipPackages \
    && find /usr/local \
		\( -type d -a -name test -o -name tests \) \
		-o \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
		-exec rm -rf '{}' + \
	&& apt-get purge -y --auto-remove $buildDeps

# make directories
RUN mkdir -p ${APPDIR} && \
    mkdir -p ${DEPLOYMENTDIR} && \
    mkdir -p ${MEDIADIR} && \
    mkdir -p ${STATICDIR} && \
    mkdir -p ${LOGDIR} && \
    mkdir -p ${SCRIPTSDIR} && \
    mkdir -p ${RUNDIR}

# set correct permissions
RUN chown -R www-data ${ROOT}

# add default files
ADD ${CONFSRC} ${CONFDIR}
ADD ${SCRIPTSSRC} ${SCRIPTSDIR}

# add app files, only on build
ONBUILD ADD ${APPSRC} ${APPDIR}
ONBUILD ADD ${DEPLOYMENTSRC} ${DEPLOYMENTDIR}

# expose http port
EXPOSE ${PORT}

# expose uwsgi-status port
EXPOSE ${STATUSPORT}

# expose uwsgi port
EXPOSE ${UWSGIPORT}

# expose volumes
VOLUME ${MEDIADIR}
VOLUME ${STATICDIR}
VOLUME ${LOGDIR}

# set workdir
WORKDIR ${APPDIR}

# make symlink for run script
RUN ln -s ${SCRIPTSDIR}/run.sh /usr/local/bin/run

# set run command
CMD run app
