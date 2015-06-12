###########################################################
# VikingCo: Django Web Stack (Python 3.4)
###########################################################
FROM python:3.4-slim
MAINTAINER Dirk Moors

ENV PYTHONUNBUFFERED 1

ENV CONFDIR /tmp/conf

ENV ROOT /opt/python

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

ENV SERVER_NAME example.com
ENV PORT 8080

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
	    nginx \
        sqlite3 \
        supervisor \
	' \
	&& requiredPipPackages=' \
	    uwsgi \
        Jinja2 \
	' \
	&& apt-get update \
	&& apt-get install -y $buildDeps $requiredAptPackages --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    && echo "daemon off;" >> /etc/nginx/nginx.conf \
    && rm /etc/nginx/sites-enabled/default \
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

# expose volumes
VOLUME ${APPDIR}
VOLUME ${MEDIADIR}
VOLUME ${STATICDIR}
VOLUME ${LOGDIR}

# expose supervisor-stats port
EXPOSE 9001

# expose uwsgi-status port
EXPOSE 7777

# expose web port
EXPOSE ${PORT}

# set workdir
WORKDIR ${ROOT}

CMD ${SCRIPTSDIR}/run.sh
