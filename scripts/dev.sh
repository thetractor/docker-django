#!/usr/bin/env bash

echo "Running Development Server..."
export DJDEBUG=1
python ${MANAGEFILE} runserver 0.0.0.0:${PORT}
