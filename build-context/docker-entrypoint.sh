#!/bin/bash

if [ "$1" = "init" ]; then
  cat /etc/iotedge/config.yaml.template \
  | sed 's;  uri: "unix:///var/run/docker.sock";  docker_uri: "/var/run/docker.sock";g' \
  | sed 's/management_uri:\s*"[^"]*"/management_uri: "http:\/\/\$HOST_IP:15580"/g' \
  | sed 's/workload_uri:\s*"[^"]*"/workload_uri: "http:\/\/\$HOST_IP:15581"/g' \
  | sed 's/hostname:\s*"[^"]*"/hostname: "$HOSTNAME"/g' > /config/config.yaml.template

  [ ! -f "/config/config.yaml"  ] && cp /config/config.yaml.template /config/config.yaml
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
  export HOST_IP=$(eval $(echo "docker inspect $HOSTNAME | jq --raw-output '.[].NetworkSettings.Networks."'"'$network'"'".IPAddress'"))
  cat /config/config.yaml | envsubst > /etc/iotedge/config.yaml
  exec iotedged -c /etc/iotedge/config.yaml
fi

