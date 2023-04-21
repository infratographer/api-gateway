GATEWAY_IMAGE=ghcr.io/infratographer/api-gateway
GATEWAY_IMAGE_TAG?=latest
KRAKEND_PORT?=8080
LOADBALANCER_API_BACKEND_HOSTS?=http://host.docker.internal:7608

# Krakend flexible configuration
# https://www.krakend.io/docs/configuration/flexible-config/
FC_ENABLE?=1
FC_SETTINGS?=/etc/krakend/settings
FC_PARTIALS?=/etc/krakend/partials
FC_TEMPLATES?=/etc/krakend/templates
FC_OUT?=/workdir/krakend.yml

.PHONY: help
help: Makefile ## Print help
	@grep -h "##" $(MAKEFILE_LIST) | grep -v grep | sed -e 's/:.*##/#/' | column -c 2 -t -s#

.PHONY: check
check:	## Run verification on krakend tmpl config
	@echo "Verifying the endpoints and config"
	@docker run \
		--rm -t \
		-v $(PWD):/workdir \
		-v $(PWD)/config:/etc/krakend/ \
		-e KRAKEND_PORT=${KRAKEND_PORT} \
		-e LOADBALANCER_API_BACKEND_HOSTS=${LOADBALANCER_API_BACKEND_HOSTS} \
		-e FC_ENABLE=${FC_ENABLE} \
		-e FC_SETTINGS=${FC_SETTINGS} \
		-e FC_PARTIALS=${FC_PARTIALS} \
		-e FC_TEMPLATES=${FC_TEMPLATES} \
		-e FC_OUT=${FC_OUT} \
		$(LOCAL_RUN_ARGS) devopsfaith/krakend check -dtc krakend.tmpl

.PHONY: gateway-image
gateway-image: check ## Generate the krakend configuration and build the image
	@echo "building API image..."
	@docker build --no-cache -t $(GATEWAY_IMAGE):$(GATEWAY_IMAGE_TAG) -f Dockerfile .
	@echo "endpoints image available in $(GATEWAY_IMAGE):$(GATEWAY_IMAGE_TAG)"

.PHONY: run-local
run-local: gateway-image ## Build and run local api gateway
	@echo Starting api gateway...
	@docker run --rm \
		-v $(PWD)/config:/etc/krakend/ \
		-p ${KRAKEND_PORT}:${KRAKEND_PORT} \
		-e LOADBALANCER_API_BACKEND_HOSTS=${LOADBALANCER_API_BACKEND_HOSTS} \
		-e FC_ENABLE=${FC_ENABLE} \
		-e FC_SETTINGS=${FC_SETTINGS} \
		-e FC_PARTIALS=${FC_PARTIALS} \
		-e FC_TEMPLATES=${FC_TEMPLATES} \
		$(GATEWAY_IMAGE):$(GATEWAY_IMAGE_TAG)
