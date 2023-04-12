# Infratographer API-GATEWAY

This repo contains the api-gateway for infratographer. This is the API that all infratographer eco systems tools are being built against. 

The goal is to provide an easy way for end users to add additional endpoints for custom components as well as replace infratographer provided components with components that provide the same API interfaces.

## Building a config

You can leverage this repository to build a krakend config from the given templates.

### Using Docker

```shell
docker run \
--rm -it -p "8080:8080" \
-v "$PWD:/etc/krakend" \
-e FC_ENABLE=1 \
-e FC_SETTINGS=config/settings/prod \
-e FC_PARTIALS=config/partials \
-e FC_TEMPLATES=config/templates \
-e FC_OUT=krakend.json \
-e SERVICE_NAME="Infratographer API Gateway" \
devopsfaith/krakend check -t -d -c "krakend.tmpl"
```

### Using Docker Compose

Based on the definition included in the [docker-compose.yml](docker-compose.yml) definition.

```shell
$ docker-compose up
```

### Using the binary locally

```shell
FC_ENABLE=1 \
FC_SETTINGS=config/settings \
FC_PARTIALS=config/partials \
FC_TEMPLATES=config/templates \
FC_OUT=krakend.json \
SERVICE_NAME="Infratographer API Gateway" \
krakend check -tdc "krakend.tmpl"
```

Note: both above alternatives will output a `krakend.json` file with the compiled version of the config file, useful for debugging purposes.
