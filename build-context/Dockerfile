FROM ubuntu:bionic as base

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get autoremove -y \
    && apt-get install -y \
    curl \
    gettext-base \
    iproute2 \
    gnupg2

RUN curl https://packages.microsoft.com/config/debian/stretch/multiarch/prod.list > ./microsoft-prod-arm.list
RUN cp ./microsoft-prod-arm.list /etc/apt/sources.list.d/
RUN curl https://packages.microsoft.com/config/ubuntu/18.04/multiarch/prod.list > ./microsoft-prod.list
RUN cp ./microsoft-prod.list /etc/apt/sources.list.d/
RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
RUN cp ./microsoft.gpg /etc/apt/trusted.gpg.d/

RUN apt-get update
RUN apt-get install -y moby-engine
RUN apt-get install -y iotedge
RUN apt-get remove -y moby-engine

RUN cp -r /etc/iotedge/ /etc/iotedge.copy/
RUN apt-get clean && rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*
COPY docker-entrypoint.sh / 
RUN chmod +x /docker-entrypoint.sh


FROM scratch as final
LABEL maintainer = Wago <dirk.meihoefer@wago.com>
LABEL maintainer = Wago <sergei.ikkert@wago.com>
COPY --from=base / /
WORKDIR /
ENTRYPOINT ["/bin/bash", "/docker-entrypoint.sh"]
