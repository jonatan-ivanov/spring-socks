#! /bin/bash

while true; do
    sleep 0.2 && curl -s 'http://localhost/?devMode=false' > /dev/null
    echo -n '.'
done
