# TODO: Add renovate configuration that will track GitHub releases
# The intent is to use release tags instead of commit hashes
FROM ghcr.io/infratographer/porton/porton:latest

USER root

ARG CONFIG_FILE=/etc/krakend-src/config/krakend.yml

# Install the configuration file in the expected path
COPY --chown=1000:1000 krakend.yml ${CONFIG_FILE}
USER 1000:1000

# required flexible configuration to enable yaml
ENV FC_OUT=${CONFIG_FILE}

ENTRYPOINT [ "/usr/bin/krakend" ]
CMD [ "run", "-c", "/etc/krakend-src/config/krakend.yml" ]
