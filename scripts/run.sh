#!/bin/bash
set -e

# Make Configurations
${SCRIPTSDIR}/make_configurations.sh

# Run supervisor
supervisord
