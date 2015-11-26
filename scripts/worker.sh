#!/usr/bin/env bash

echo "Running Worker (Celery)..."
celery worker \
    --uid=www-data \
    --gid=www-data \
    --app=${CELERYAPP} \
    --loglevel=${CELERYWORKER_LOGLEVEL}
