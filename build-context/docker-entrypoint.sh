#!/bin/bash

if [ "$1" = "init" ]; then
  cat /etc/iotedge.copy/config.yaml.template \
  | sed 's;  uri: "unix:///var/run/docker.sock";  docker_uri: "/var/run/docker.sock";g' \
  | sed 's/management_uri:\s*"[^"]*"/management_uri: "http:\/\/\$HOST_IP:15580"/g' \
  | sed 's/workload_uri:\s*"[^"]*"/workload_uri: "http:\/\/\$HOST_IP:15581"/g' \
  | sed 's/hostname:\s*"[^"]*"/hostname: "$HOSTNAME"/g' > /etc/iotedge/config.yaml.template

  [ ! -f "/config/config.yaml"  ] && cp /etc/iotedge/config.yaml.template /config/config.yaml
  chmod 444 /config/*
else
  network=$(cat /config/config.yaml \
  | sed ':a;N;$!ba;s/\n/@/g' \
  | sed 's/\s//g' \
  | grep -Po '((?<=@network:@name:")[^"]*|(?<=@network:")[^"]*)')
  [ -z "$network" ] && network="azure-iot-edge"
  echo $network
  echo $HOSTNAME
  docker network create $network
  docker network connect $network $HOSTNAME
  export HOST_IP=$(ip addr show eth1 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
  cat /config/config.yaml | envsubst > /etc/iotedge/config.yaml
  exec iotedged -c /etc/iotedge/config.yaml
fi

