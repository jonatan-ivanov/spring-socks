# Spring Socks

![Spring Socks](shop-ui/src/main/resources/static/img/logo.png)

Slow version of https://github.com/making/spring-socks

<img src="https://user-images.githubusercontent.com/106908/95973135-3ab35000-0e4e-11eb-9267-00ab2bee3c5f.png" width="800px">

## Why is it slow?

The goal of this project is simulating production issues so parts of the web app are artificially and ridiculously slow. There is one slow operation that is used in multiple places in the app: querying multiple products from the Catalog DB.

We did not introduce this artificial slowness by using `Thread::sleep` or any latency-proxy. The cause of the slowness is the lack of pagination (SQL `LIMIT`) and the amount of data in the DB. The `SockGen` class generates a DB migration script with a few products (5) that have quite big description fields (~20MiB). When somebody queries these products, the query will be quite slow (~5sec) because of the huge amout of data (~100MiB). Normally, with pagination these records are not queried because the query is ordered by price and we made these records quite expensive, so normally they are not returned. If somebody fetches all the records, these will be in the result too, so the query becomes slow.

## How to run Spring Socks locally

1. Run `docker-compose up` in the project's root directory  
   This should start MySQL, Adminer, and Zipkin
1. `export WAVEFRONT_API_TOKEN=...`
1. `export LOGZ_IO_API_TOKEN=...`
1. `idea .` (imports the project keeping the environment variables set)
1. Execute `SockGen` which should create a migration script in `catalog-api/src/main/resources/db/migration` named `V5__add_looong_socks.sql`
Do not open this file as its size should be around 100MiB.
1. Start `UserApiApplication`
1. Start the rest of the applications except `ShopUiApplication`: `CartApiApplication`, `CatalogApiApplication`, `OrderApiApplication`, `PaymentApiApplication`, `ShippingApiApplication`
1. Start `ShopUiApplication`
1. `http://localhost`

If you want the app to be fast for the next request: `http://localhost/?devMode=false`

## Other How to run examples

* [How to run Spring Socks with Docker Compose](docs/docker-compose.md)
* [How to deploy Spring Socks on Kubernetes](docs/k8s.md)
* [How to deploy Spring Socks on Cloud Foundry](docs/cf.md)

## API Docs

| API | OpenAPI Spec | Code |　Docker Image |
| --- | --- | --- | --- |
| Catalog API | [catalog-spec](./catalog-spec) [![catalog-spec](https://github.com/making/spring-socks/workflows/catalog-spec/badge.svg)](https://github.com/making/spring-socks/actions?query=workflow%3Acatalog-spec) <br> [[ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/making/spring-socks/master/catalog-spec/openapi/doc.yml)] [[Swagger UI](https://petstore.swagger.io/?url=https://raw.githubusercontent.com/making/spring-socks/master/catalog-spec/openapi/doc.yml)] | [catalog-api](./catalog-api) [![catalog-api](https://github.com/making/spring-socks/workflows/catalog-api/badge.svg)](https://github.com/making/spring-socks/actions?query=workflow%3Acatalog-api) | [`ghcr.io/making/spring-socks-catalog`](https://github.com/users/making/packages/container/package/spring-socks-catalog) |
| Cart API | [cart-spec](./cart-spec) [![cart-spec](https://github.com/making/spring-socks/workflows/cart-spec/badge.svg)](https://github.com/making/spring-socks/actions?query=workflow%3Acart-spec) <br> [[ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/making/spring-socks/master/cart-spec/openapi/doc.yml)] [[Swagger UI](https://petstore.swagger.io/?url=https://raw.githubusercontent.com/making/spring-socks/master/cart-spec/openapi/doc.yml)] | [cart-api](./cart-api) [![cart-api](https://github.com/making/spring-socks/workflows/cart-api/badge.svg)](https://github.com/making/spring-socks/actions?query=workflow%3Acart-api) | [`ghcr.io/making/spring-socks-cart`](https://github.com/users/making/packages/container/package/spring-socks-cart) |
| Order API | [order-spec](./order-spec) [![order-spec](https://github.com/making/spring-socks/workflows/order-spec/badge.svg)](https://github.com/making/spring-socks/actions?query=workflow%3Aorder-spec) <br> [[ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/making/spring-socks/master/order-spec/openapi/doc.yml)] [[Swagger UI](https://petstore.swagger.io/?url=https://raw.githubusercontent.com/making/spring-socks/master/order-spec/openapi/doc.yml)] | [order-api](./order-api) [![order-api](https://github.com/making/spring-socks/workflows/order-api/badge.svg)](https://github.com/making/spring-socks/actions?query=workflow%3Aorder-api) | [`ghcr.io/making/spring-socks-order`](https://github.com/users/making/packages/container/package/spring-socks-order) |
| Payment API | [payment-spec](./payment-spec) [![payment-spec](https://github.com/making/spring-socks/workflows/payment-spec/badge.svg)](https://github.com/making/spring-socks/actions?query=workflow%3Apayment-spec) <br> [[ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/making/spring-socks/master/payment-spec/openapi/doc.yml)] [[Swagger UI](https://petstore.swagger.io/?url=https://raw.githubusercontent.com/making/spring-socks/master/payment-spec/openapi/doc.yml)] | [payment-api](./payment-api) [![payment-api](https://github.com/making/spring-socks/workflows/payment-api/badge.svg)](https://github.com/making/spring-socks/actions?query=workflow%3Apayment-api) | [`ghcr.io/making/spring-socks-payment`](https://github.com/users/making/packages/container/package/spring-socks-payment) |
| Shipping API | [shipping-spec](./shipping-spec) [![shipping-spec](https://github.com/making/spring-socks/workflows/shipping-spec/badge.svg)](https://github.com/making/spring-socks/actions?query=workflow%3Ashipping-spec) <br> [[ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/making/spring-socks/master/shipping-spec/openapi/doc.yml)] [[Swagger UI](https://petstore.swagger.io/?url=https://raw.githubusercontent.com/making/spring-socks/master/shipping-spec/openapi/doc.yml)] | [shipping-api](./shipping-api) [![shipping-api](https://github.com/making/spring-socks/workflows/shipping-api/badge.svg)](https://github.com/making/spring-socks/actions?query=workflow%3Ashipping-api) | [`ghcr.io/making/spring-socks-shipping`](https://github.com/users/making/packages/container/package/spring-socks-shipping) |
| User API | [user-spec](./user-spec) [![user-spec](https://github.com/making/spring-socks/workflows/user-spec/badge.svg)](https://github.com/making/spring-socks/actions?query=workflow%3Auser-spec) <br> [[ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/making/spring-socks/master/user-spec/openapi/doc.yml)] [[Swagger UI](https://petstore.swagger.io/?url=https://raw.githubusercontent.com/making/spring-socks/master/user-spec/openapi/doc.yml)] | [user-api](./user-api) [![user-api](https://github.com/making/spring-socks/workflows/user-api/badge.svg)](https://github.com/making/spring-socks/actions?query=workflow%3Auser-api) | [`ghcr.io/making/spring-socks-user`](https://github.com/users/making/packages/container/package/spring-socks-user) |
| Shop UI | - | [shop-ui](./shop-ui) [![shop-ui](https://github.com/making/spring-socks/workflows/shop-ui/badge.svg)](https://github.com/making/spring-socks/actions?query=workflow%3Ashop-ui) | [`ghcr.io/making/spring-socks-ui`](https://github.com/users/making/packages/container/package/spring-socks-ui) |