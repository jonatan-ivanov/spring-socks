#! /bin/bash

mkdir -p fake-logs/content

for i in {0..9}; do
    if [ "$((i % 2))" == 0 ]; then
        touch "fake-logs/content/cart-api.2021-09-02T02:0$i:00Z.tar.gz"
        touch "fake-logs/content/catalog-api.2021-09-02T02:0$i:00Z.tar.gz"
        touch "fake-logs/content/order-api.2021-09-02T02:0$i:00Z.tar.gz"
        touch "fake-logs/content/payment-api.2021-09-02T02:0$i:00Z.tar.gz"
        touch "fake-logs/content/shipping-api.2021-09-02T02:0$i:00Z.tar.gz"
        touch "fake-logs/content/user-api.2021-09-02T02:0$i:00Z.tar.gz"
        touch "fake-logs/content/shop-ui.2021-09-02T02:0$i:00Z.tar.gz"
    fi
done

touch "fake-logs/content/cart-api.log"
touch "fake-logs/content/catalog-api.log"
touch "fake-logs/content/order-api.log"
touch "fake-logs/content/payment-api.log"
touch "fake-logs/content/shipping-api.log"
touch "fake-logs/content/user-api.log"
touch "fake-logs/content/shop-ui.log"
