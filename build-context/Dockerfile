#FROM arm32v7/ubuntu:16.04 as base
FROM arm32v7/debian:stretch-slim as base

LABEL maintainer = Wago <dirk.meihoefer@wago.com>
LABEL maintainer = Wago <sergei.ikkert@wago.com>

COPY resources / 

RUN set -x 
RUN apt -y update
RUN apt -y install  --no-install-recommends apt-transport-https 
RUN apt -y install  --no-install-recommends ca-certificates 
RUN apt -y install  --no-install-recommends curl 
RUN apt -y install  --no-install-recommends iptables
RUN apt -y install  --no-install-recommends iproute2
RUN apt -y install  --no-install-recommends libcurl3
RUN apt -y install  --no-install-recommends libffi-dev
RUN apt -y install  --no-install-recommends libssl1.0.2
RUN apt -y install  --no-install-recommends libssl-dev
RUN apt -y install  --no-install-recommends systemd
RUN curl --insecure -L https://aka.ms/moby-engine-armhf-latest -o moby_engine.deb && dpkg -i ./moby_engine.deb && rm ./moby_engine.deb && \
    curl --insecure -L https://aka.ms/moby-cli-armhf-latest -o moby_cli.deb && dpkg -i ./moby_cli.deb && rm ./moby_cli.deb
RUN curl --insecure -L https://aka.ms/libiothsm-std-linux-armhf-latest -o libiothsm-std.deb && dpkg -i ./libiothsm-std.deb && rm ./libiothsm-std.deb && \
    curl --insecure -L https://aka.ms/iotedged-linux-armhf-latest -o iotedge.deb && dpkg -i ./iotedge.deb && rm ./iotedge.deb
RUN apt update && apt install -f
RUN apt-get -y autoremove
RUN apt-get clean && rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*
WORKDIR /lib/arm-linux-gnueabihf/

RUN ln -s libcrypto.so.1.0.0 libcrypto.so.1.0.2 && \
    ln -s libssl.so.1.0.0 libssl.so.1.0.2


FROM scratch as final
COPY --from=base / /
WORKDIR /
CMD ["./iot-edge-starter"]