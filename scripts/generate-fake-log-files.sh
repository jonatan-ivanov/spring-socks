#! /bin/bash

mkdir -p fake-logs

for i in {0..9}; do
    if [ "$((i % 2))" == 0 ]; then
        touch "fake-logs/cart-api.2021-08-31T02:0$i:00Z.tar.gz"
        touch "fake-logs/catalog-api.2021-08-31T02:0$i:00Z.tar.gz"
        touch "fake-logs/order-api.2021-08-31T02:0$i:00Z.tar.gz"
        touch "fake-logs/payment-api.2021-08-31T02:0$i:00Z.tar.gz"
        touch "fake-logs/shipping-api.2021-08-31T02:0$i:00Z.tar.gz"
        touch "fake-logs/user-api.2021-08-31T02:0$i:00Z.tar.gz"
        touch "fake-logs/shop-ui.2021-08-31T02:0$i:00Z.tar.gz"
    fi
done

touch "fake-logs/cart-api.log"
touch "fake-logs/catalog-api.log"
touch "fake-logs/order-api.log"
touch "fake-logs/payment-api.log"
touch "fake-logs/shipping-api.log"
touch "fake-logs/user-api.log"
touch "fake-logs/shop-ui.log"
