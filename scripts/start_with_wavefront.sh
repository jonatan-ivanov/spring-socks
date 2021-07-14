#!/bin/bash

set -o errexit

export LOGZ_IO_API_TOKEN="${LOGZ_IO_API_TOKEN:-}"
export TOKENS="${TOKENS:-}"
export PROFILES="${PROFILES:-wavefront}"

if [[ "${LOGZ_IO_API_TOKEN}" != "" ]]; then
  echo "Logz io token present - will enable the logzio profile"
  PROFILES="${PROFILES},logzio"
  TOKENS="--spring.profiles.active=wavefront,logzio"
  rm -rf /tmp/logzio-logback-queue/
else
  echo "Logz io token missing"
  TOKENS="--spring.profiles.active=wavefront"
fi

./scripts/build_apps.sh

WAVEFRONT_API_TOKEN="${WAVEFRONT_API_TOKEN:-}"
echo "Will append the following runtime arguments [${TOKENS}] together with the Wavefront token"
TOKENS="${TOKENS} --management.metrics.export.wavefront.api-token=${WAVEFRONT_API_TOKEN}"

echo "Starting the docker infrastructure"
docker-compose up -d
echo "Waiting for the docker infra to start - please wait..."
sleep 30

./scripts/start_apps.sh