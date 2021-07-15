#!/bin/bash

echo "Running apps:"
jps | grep "1.0.0-SPRING_ONE.jar"

echo "Running docker processes"
docker-compose ps

echo "Killing processes"
kill `jps | grep "1.0.0.SPRING_ONE.jar" | cut -d " " -f 1` || echo "No apps running"
pkill -9 -f 1.0.0.SPRING_ONE.jar || echo "Apps not running"
docker-compose kill

echo "Running apps:"
jps | grep "1.0.0.SPRING_ONE.jar"

echo "Running docker processes"
docker-compose ps

echo "Removing the magical logzio folder"
 rm -rf /tmp/logzio-logback-queue