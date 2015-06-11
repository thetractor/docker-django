###########################################################
# VikingCo: Django Web Stack (Python 3.4)
###########################################################
FROM python:3.4
MAINTAINER Dirk Moors

ENV CONFDIR /tmp/conf
ENV SCRIPTSDIR /tmp/scripts

ENV APPDIR /opt/python/app
ENV MEDIADIR /opt/python/media
ENV STATICDIR /opt/python/static
ENV LOGDIR /opt/python/logs
ENV RUNDIR /opt/python/run

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
RUN mkdir -p ${APPDIR} && \
    mkdir -p ${MEDIADIR} && \
    mkdir -p ${STATICDIR} && \
    mkdir -p ${LOGDIR} && \
    mkdir -p ${RUNDIR}

# make virtualenv
RUN cd ${RUNDIR} && \
    virtualenv venv

# set correct permissions
RUN chown -R www-data ${APPDIR} && \
    chown -R www-data ${MEDIADIR} && \
    chown -R www-data ${STATICDIR} && \
    chown -R www-data ${LOGDIR} && \
    chown -R www-data ${RUNDIR}

# add files
ADD ./app ${APPDIR}
ADD ./conf ${CONFDIR}
ADD ./scripts ${SCRIPTSDIR}

# install requirements
RUN . ${RUNDIR}/venv/bin/activate && pip install -r ${DJANGO_REQUIREMENTS_FILE}

# make configuration files
RUN ${SCRIPTSDIR}/make_configurations.sh

# restart services
#RUN service nginx restart
#RUN service uwsgi restart

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

CMD supervisord
