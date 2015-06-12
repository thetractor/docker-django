###########################################################
# VikingCo: Django Web Stack (Python 3.4)
###########################################################
FROM python:3.4
MAINTAINER Dirk Moors

ENV PYTHONUNBUFFERED 1

ENV CONFDIR /tmp/conf

ENV HOME /opt/python

ENV APPSRC ./app
ENV DEPLOYMENTSRC ./deployment
ENV CONFSRC ./conf
ENV SCRIPTSSRC ./scripts

ENV APPDIR ${HOME}/app
ENV DEPLOYMENTDIR ${HOME}/deployment
ENV MEDIADIR ${HOME}/media
ENV STATICDIR ${HOME}/static
ENV LOGDIR ${HOME}/logs
ENV RUNDIR ${HOME}/run
ENV SCRIPTSDIR ${HOME}/scripts

ENV SERVER_NAME example.com
ENV PORT 8080

ENV DJANGO_REQUIREMENTS_FILE ${DEPLOYMENTDIR}/requirements-production.txt
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
RUN mkdir -p ${APPDIR} && \
    mkdir -p ${DEPLOYMENTDIR} && \
    mkdir -p ${MEDIADIR} && \
    mkdir -p ${STATICDIR} && \
    mkdir -p ${LOGDIR} && \
    mkdir -p ${SCRIPTSDIR} && \
    mkdir -p ${RUNDIR}

# make virtualenv
RUN cd ${RUNDIR} && \
    virtualenv venv

# set correct permissions
RUN chown -R www-data ${HOME}

# add default files
ADD ${CONFSRC} ${CONFDIR}
ADD ${SCRIPTSSRC} ${SCRIPTSDIR}

# add app files
ONBUILD ADD ${APPSRC} ${APPDIR}
ONBUILD ADD ${DEPLOYMENTSRC} ${DEPLOYMENTDIR}

# install requirements
ONBUILD RUN . ${RUNDIR}/venv/bin/activate && pip install -r ${DJANGO_REQUIREMENTS_FILE}

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

CMD ${SCRIPTSDIR}/run.sh
