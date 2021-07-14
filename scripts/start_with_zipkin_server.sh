#!/bin/bash

set -o errexit

export LOGZ_IO_API_TOKEN="${LOGZ_IO_API_TOKEN:-}"
export TOKENS="${TOKENS:-}"
export PROFILES="${PROFILES:-zipkin}"

if [[ "${LOGZ_IO_API_TOKEN}" != "" ]]; then
  echo "Logz io token present - will enable the logzio profile"
  PROFILES="${PROFILES},logzio"
  TOKENS="--spring.profiles.active=zipkin,logzio"
  rm -rf /tmp/logzio-logback-queue/
else
  echo "Logz io token missing"
  TOKENS="--spring.profiles.active=zipkin"
fi

./scripts/build_apps.sh

echo "Starting the docker infrastructure"
docker-compose up -d
echo "Waiting for the docker infra to start - please wait..."
sleep 30

./scripts/start_apps.sh