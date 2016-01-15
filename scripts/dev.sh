#!/usr/bin/env bash

echo "Running Development Server..."
export DJDEBUG=1
python ${MANAGE_FILE} runserver 0.0.0.0:${PORT}
