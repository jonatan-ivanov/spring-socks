#! /bin/bash

while true; do
    sleep 3 && curl -s 'http://localhost/' > /dev/null
    echo -n '.'
done
