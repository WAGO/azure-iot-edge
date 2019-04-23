# docker-arm32v7-iot-edge
Docker image for running Microsoft IoT Edge runtime on arm32v7 devices like WAGOs PFC200/100.

# How to setup Azure Iot Edge on Wago Device

## Prerequisites for tutorial
- Preinstalled SSH Client (e.g. https://www.putty.org/)
- Microsoft Azure Account 
  - Firmware you can find here: https://github.com/WAGO/pfc-firmware
  - Docker IPKG you can find here: https://github.com/WAGO/docker-ipk 



Create an Iot hub and add edge device see: 
https://docs.microsoft.com/de-de/azure/iot-edge/tutorial-simulate-device-linux

## PFC Login
Start SSH Client e.g. Putty 
 ```bash
login as `root`
password `wago`
 ```
## Check docker installation

```bash
docker info
docker ps # to see all running container (no container should run)
docker images # to see all preinstalled images
 ```
## Setup azure iot Edge
 
 Create new directories on device for persisting azure iot edge artifacts. (e.g. certificates, deployment)
  ```bash
 mkdir /etc/azure-iot-edge
 chmod 777 /etc/azure-iot-edge
 mkdir /var/lib/azure-iot-edge
 chmod 777 /var/lib/azure-iot-edge
 ```
Start azure iot edge runtime container 
 ```bash
  docker run \
    -it \
    --name azure-iot-edge-runtime \
    -v //var//run//docker.sock://var//run//docker.sock \
    -v /etc/os-release:/etc/os-release
    -v /etc/azure-iot-edge:/etc/azure-iot-edge \
    -v /var/lib/azure-iot-edge:/var/lib/azure-iot-edge \
    -p 15580:15580 \
    -p 15581:15581 \
    -e IOT_DEVICE_CONNSTR="$IOT_DEVICE_CONNSTR" \
    wagoautomation/azure-iot-edge
  bin/bash
  ```

Finally, Wago device is ready for azure iot edge module deployment! <br>
Happy IoTing!

## Deploy your first IoT Edge Module

https://docs.microsoft.com/de-de/azure/iot-edge/quickstart-linux

## Azure IoT Edge Modbus Module

You need a running Modbus Slave (Server) e.g. Wago Device or Modbus slave Simulator  

How to deploy microsoft modbus ingestion module see here: 
https://github.com/Azure/iot-edge-modbus


## Develop a C# IoT Edge module

How to develop your own azure iot edge module see here: 
https://docs.microsoft.com/en-us/azure/iot-edge/tutorial-csharp-module

