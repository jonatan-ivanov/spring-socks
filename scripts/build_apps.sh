#!/bin/bash

set -o errexit

PROFILES="${PROFILES:-}"

echo "Building the apps with maven profiles [${PROFILES}]"
./mvnw clean package -P"${PROFILES}" -DskipTests -T 4
