#!/bin/bash
set -e

args=("$@")
USER=${args[0]}
GROUP=${args[1]}

# Validate required environment variables
if [ -z "${USER}" ] || [ -z "${GROUP}" ]; then
    echo "ERROR: USER and GROUP environment variables must be set"
    exit 1
fi

# Update Supervisord configuration
file=./supervisord.conf
if [ -e "$file" ]; then
    # Update chown in [unix_http_server] section
    sed -i "s/^chown=.*/chown=${USER}:${GROUP}/" ./docker/config/supervisor/supervisord.conf
else
    # Create file and update chown in [unix_http_server] section
    cp ./docker/config/supervisor/supervisord.conf.sample ./docker/config/supervisor/supervisord.conf
    sed -i "s/^chown=.*/chown=${USER}:${GROUP}/" ./docker/config/supervisor/supervisord.conf
fi
