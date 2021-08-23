#! /bin/bash

while true; do
    sleep 0.5 && curl -s 'http://localhost/?devMode=false' > /dev/null
    echo -n '.'
done
