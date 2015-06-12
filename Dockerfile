###########################################################
# VikingCo: Django Web Stack (Python 3.4)
###########################################################
FROM python:3.4
MAINTAINER Dirk Moors

ENV CONFDIR /tmp/conf

ENV HOME /opt/python

ENV APPSRC ./app
ENV CONFSRC ./conf
ENV SCRIPTSSRC ./scripts

ENV APPDIR ${HOME}/app
ENV MEDIADIR ${HOME}/media
ENV STATICDIR ${HOME}/static
ENV LOGDIR ${HOME}/logs
ENV RUNDIR ${HOME}/run
ENV SCRIPTSDIR ${HOME}/scripts

ENV SERVER_NAME example.com
ENV PORT 8080

ENV DJANGO_REQUIREMENTS_FILE ${APPDIR}/requirements.txt
ENV DJANGO_SETTINGS_MODULE service.settings

# install apt packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        build-essential \
        python3-dev \
        nginx \
        sqlite3 \
        supervisor

# disable nginx daemon
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# remove default sites
RUN rm /etc/nginx/sites-enabled/default

# install python packages
RUN pip install --upgrade pip && \
    pip install uwsgi && \
    pip install Jinja2 && \
    pip install virtualenv

# make directories
ONBUILD RUN \
    mkdir -p ${APPDIR} && \
    mkdir -p ${MEDIADIR} && \
    mkdir -p ${STATICDIR} && \
    mkdir -p ${LOGDIR} && \
    mkdir -p ${SCRIPTSDIR} && \
    mkdir -p ${RUNDIR}

# make virtualenv
ONBUILD RUN cd ${RUNDIR} && \
    virtualenv venv

# set correct permissions
ONBUILD RUN chown -R www-data ${HOME}

# add default files
ONBUILD ADD ${APPSRC} ${APPDIR}
ONBUILD ADD ${CONFSRC} ${CONFDIR}
ONBUILD ADD ${SCRIPTSSRC} ${SCRIPTSDIR}

# install requirements
ONBUILD RUN . ${RUNDIR}/venv/bin/activate && pip install -r ${DJANGO_REQUIREMENTS_FILE}

# expose volumes
ONBUILD VOLUME ${APPDIR}
ONBUILD VOLUME ${MEDIADIR}
ONBUILD VOLUME ${STATICDIR}
ONBUILD VOLUME ${LOGDIR}

# expose supervisor-stats port
ONBUILD EXPOSE 9001

# expose uwsgi-status port
ONBUILD EXPOSE 7777

# expose web port
ONBUILD EXPOSE ${PORT}

ONBUILD CMD ${SCRIPTSDIR}/run.sh
