#!/usr/bin/env bash

if [ -z "${CELERY_APP}" ]; then
    echo "You need to set environment variable \"CELERY_APP\"!";
else
    echo "Running Worker (Celery)..."
    celery worker \
        --uid=${USERNAME} \
        --gid=${GROUPNAME} \
        --app=${CELERY_APP} \
        --loglevel=${CELERY_WORKER_LOGLEVEL:-INFO}
fi
