ARG IOTEDGE_VERSION=1.1.0-1
FROM ubuntu:bionic as base
ARG IOTEDGE_VERSION

# update and install required packages
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get autoremove -y && \
    apt-get install -y \
    curl \
    gettext-base \
    iproute2 \
    gnupg2 \
    jq 

# add custom repository
RUN curl https://packages.microsoft.com/config/debian/stretch/multiarch/prod.list > ./microsoft-prod-arm.list && \
    cp ./microsoft-prod-arm.list /etc/apt/sources.list.d/ && \
    curl https://packages.microsoft.com/config/ubuntu/18.04/multiarch/prod.list > ./microsoft-prod.list && \
    cp ./microsoft-prod.list /etc/apt/sources.list.d/ && \
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg && \
    cp ./microsoft.gpg /etc/apt/trusted.gpg.d/

# install IoT Edge (create a docker group to prevent "no container runtime detected" error)
RUN groupadd docker --force && \
    apt-get update -y && \
    apt-get install -y \
    moby-cli \
    libiothsm-std=${IOTEDGE_VERSION} \    
    iotedge=${IOTEDGE_VERSION}    

#RUN apt-get remove -y moby-cli

# cleanup
RUN apt-get -y autoremove && \
    apt-get clean && rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY docker-entrypoint.sh / 
RUN chmod +x /docker-entrypoint.sh

# second stage in docker build process to reduce image size
FROM scratch as final
ARG IOTEDGE_VERSION
LABEL maintainer = "Wago <dirk.meihoefer@wago.com>", "Wago <sergei.ikkert@wago.com>"
LABEL description  = "Azure IOT Edge version ${IOTEDGE_VERSION}"
COPY --from=base / /
WORKDIR /
ENTRYPOINT ["/bin/bash", "/docker-entrypoint.sh"]
