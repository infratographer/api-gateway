# Infratographer API-GATEWAY

This repo contains a reference implementation of the api-gateway for infratographer.

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
