#!/usr/bin/env bash

set -o errexit

export KILL_AT_END="${KILL_AT_END:-yes}"
export DEFAULT_HEALTH_HOST=${DEFAULT_HEALTH_HOST:-localhost}

export USER_API_PORT="${USER_API_PORT:-5006}"
export USER_API_ADDRESS="${USER_API_ADDRESS:-${DEFAULT_HEALTH_HOST}:${USER_API_PORT}}"
export CART_API_PORT="${CART_API_PORT:-5005}"
export CART_API_ADDRESS="${CART_API_ADDRESS:-${DEFAULT_HEALTH_HOST}:${CART_API_PORT}}"
export CATALOG_API_PORT="${CATALOG_API_PORT:-5001}"
export CATALOG_API_ADDRESS="${CATALOG_API_ADDRESS:-${DEFAULT_HEALTH_HOST}:${CATALOG_API_PORT}}"
export ORDER_API_PORT="${ORDER_API_PORT:-5004}"
export ORDER_API_ADDRESS="${ORDER_API_ADDRESS:-${DEFAULT_HEALTH_HOST}:${ORDER_API_PORT}}"
export PAYMENT_API_PORT="${PAYMENT_API_PORT:-5002}"
export PAYMENT_API_ADDRESS="${PAYMENT_API_ADDRESS:-${DEFAULT_HEALTH_HOST}:${PAYMENT_API_PORT}}"
export SHIPPING_API_PORT="${SHIPPING_API_PORT:-5003}"
export SHIPPING_API_ADDRESS="${SHIPPING_API_ADDRESS:-${DEFAULT_HEALTH_HOST}:${SHIPPING_API_PORT}}"
export SHOP_UI_PORT="${SHOP_UI_PORT:-80}"
export SHOP_UI_ADDRESS="${SHOP_UI_ADDRESS:-${DEFAULT_HEALTH_HOST}:${SHOP_UI_PORT}}"

export REPORTING_SYSTEM="${REPORTING_SYSTEM:-zipkin}"

echo -e "\n\nRunning apps on addresses:\n\nuser: [${USER_API_ADDRESS}]\ncart: [${CART_API_ADDRESS}]\ncatalog: [${CATALOG_API_ADDRESS}]\norder: [${ORDER_API_ADDRESS}]\npayment [${PAYMENT_API_ADDRESS}]\nshipping: [${SHIPPING_API_ADDRESS}]\nshop: [${SHOP_UI_ADDRESS}]\n\n"

if [[ "${KILL_AT_END}" == "yes" ]] ; then
    trap "{ ./scripts/kill.sh; }" EXIT
fi

# Kill the running apps
./scripts/kill.sh

echo "Running reporting system [${REPORTING_SYSTEM}]"

if [[ "${REPORTING_SYSTEM}" == "zipkin" ]]; then
  # Next run the `./runApps.sh` script to initialize Zipkin and the apps (check the `README` of `sleuth-documentation-apps` for Docker setup info)
  ./scripts/start_with_zipkin_server.sh
elif [[ "${REPORTING_SYSTEM}" == "wavefront" ]]; then
  ./scripts/start_with_wavefront.sh
else
  echo "No matching reporting system"
  exit 1
fi

./scripts/run_acceptance_tests.sh

if [[ "${KILL_AT_END}" == "yes" ]]; then
  ./scripts/kill.sh
fi