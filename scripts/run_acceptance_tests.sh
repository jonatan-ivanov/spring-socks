#!/usr/bin/env bash

set -o errexit

DEFAULT_HEALTH_HOST=${DEFAULT_HEALTH_HOST:-localhost}
SHOP_UI_PORT="${SHOP_UI_PORT:-80}"
SHOP_UI_ADDRESS="${SHOP_UI_ADDRESS:-${DEFAULT_HEALTH_HOST}:${SHOP_UI_PORT}}"

echo -e "\n\nRunning acceptance tests. Starting with OK load"
for number in {1..5}; do
  mod=$((number % 10))
  if [[ "${mod}" == 0 ]]; then
    echo "Sent [${number}] requests"
  fi
  sleep 0.5 && curl -s "http://${SHOP_UI_ADDRESS}/?devMode=false" > /dev/null;
done

echo -e "\nWill wait some time before generating KO load"
sleep 10

echo -e "\nGenerating KO load"

for number in {1..2}; do
  mod=$((number % 10))
  if [[ "${mod}" == 0 ]]; then
    echo "Sent [${number}] requests"
  fi
  sleep 3 && curl -s "http://${SHOP_UI_ADDRESS}/" > /dev/null;
done

echo -e "\nAcceptance tests done!"