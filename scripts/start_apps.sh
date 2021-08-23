#!/bin/bash

set -o errexit

DEFAULT_HEALTH_HOST=${DEFAULT_HEALTH_HOST:-localhost}
WAIT_TIME="${WAIT_TIME:-5}"
RETRIES="${RETRIES:-30}"
USER_API_PORT="${USER_API_PORT:-5006}"
CART_API_PORT="${CART_API_PORT:-5005}"
CATALOG_API_PORT="${CATALOG_API_PORT:-5001}"
ORDER_API_PORT="${ORDER_API_PORT:-5004}"
PAYMENT_API_PORT="${PAYMENT_API_PORT:-5002}"
SHIPPING_API_PORT="${SHIPPING_API_PORT:-5003}"
SHOP_UI_PORT="${SHOP_UI_PORT:-80}"
TOKENS="${TOKENS:-}"
[[ -z "${MEM_ARGS}" ]] && MEM_ARGS="-Xmx128m -Xss1024k"

JAVA="${JAVA_HOME}/bin/java"
if [[ -z "${JAVA_HOME}" ]] ; then
    JAVA="java"
fi

mkdir -p target

function check_app() {
    READY_FOR_TESTS="no"
    curl_local_health_endpoint $1 && READY_FOR_TESTS="yes" || echo "Failed to reach health endpoint"
    if [[ "${READY_FOR_TESTS}" == "no" ]] ; then
        echo "Failed to start service running at port $1"
        print_logs
        exit 1
    fi
}

# ${RETRIES} number of times will try to curl to /health endpoint to passed port $1 and localhost
function curl_local_health_endpoint() {
    curl_health_endpoint $1 "127.0.0.1"
}

# ${RETRIES} number of times will try to curl to /health endpoint to passed port $1 and host $2
function curl_health_endpoint() {
    local PASSED_HOST="${2:-$HEALTH_HOST}"
    local READY_FOR_TESTS=1
    for i in $( seq 1 "${RETRIES}" ); do
        sleep "${WAIT_TIME}"
        curl --fail -m 5 "${PASSED_HOST}:$1/actuator/health" && READY_FOR_TESTS=0 && break || echo "Failed"
        echo "Fail #$i/${RETRIES}... will try again in [${WAIT_TIME}] seconds"
    done
    return ${READY_FOR_TESTS}
}

mkdir -p target

echo -e "\nRemoving the magical logzio folder"
rm -rf /tmp/logzio-logback-queue

echo -e "\nStarting the apps..."
nohup ${JAVA} ${MEM_ARGS} -jar user-api/target/*.jar --debug --server.port="${USER_API_PORT}" ${TOKENS} > target/user-api.log 2>&1 &
echo -e "\nWaiting for the user-api to start"
check_app "${USER_API_PORT}"

echo -e "\nRemoving the magical logzio folder"
rm -rf /tmp/logzio-logback-queue

echo -e "\nStarting the rest of the apps"
nohup ${JAVA} ${MEM_ARGS} -jar cart-api/target/*.jar --debug --server.port="${CART_API_PORT}" ${TOKENS} > target/cart-api.log 2>&1 &
nohup ${JAVA} -Xmx512M -Xss1024k -jar catalog-api/target/*.jar --debug --server.port="${CATALOG_API_PORT}" ${TOKENS} > target/catalog-api.log 2>&1 &
nohup ${JAVA} ${MEM_ARGS} -jar order-api/target/*.jar --debug --server.port="${ORDER_API_PORT}" ${TOKENS} > target/order-api.log 2>&1 &
nohup ${JAVA} ${MEM_ARGS} -jar payment-api/target/*.jar --debug --server.port="${PAYMENT_API_PORT}" ${TOKENS} > target/payment-api.log 2>&1 &
nohup ${JAVA} ${MEM_ARGS} -jar shipping-api/target/*.jar --debug --server.port="${SHIPPING_API_PORT}" ${TOKENS} > target/shipping-api.log 2>&1 &

echo -e "\nRemoving the magical logzio folder"
rm -rf /tmp/logzio-logback-queue

echo -e "\n\nWaiting for all apps but UI to start\n\n"
check_app "${CART_API_PORT}"
check_app "${CATALOG_API_PORT}"
check_app "${ORDER_API_PORT}"
check_app "${PAYMENT_API_PORT}"
check_app "${SHIPPING_API_PORT}"

echo -e "\nRemoving the magical logzio folder"
rm -rf /tmp/logzio-logback-queue

echo -e "\n\nWaiting for UI to start\n\n"
nohup ${JAVA} ${MEM_ARGS} -jar shop-ui/target/*.jar --debug --server.port="${SHOP_UI_PORT}" ${TOKENS} > target/shop-ui.log 2>&1 &
echo -e "\nWaiting some time for the application to start..."
sleep 30
