## Statistics Docker Hub

[![DockerHub stars](https://img.shields.io/docker/stars/wagoautomation/azure-iot-edge.svg?flat&logo=docker "Docker Hub Stars")](https://hub.docker.com/r/wagoautomation/azure-iot-edge)
[![DockerHub pulls](https://img.shields.io/docker/pulls/wagoautomation/azure-iot-edge.svg?flat&logo=docker "Docker Hub Pulls")](https://hub.docker.com/r/wagoautomation/azure-iot-edge)
[![DockerHub build-status](https://img.shields.io/docker/cloud/build/wagoautomation/azure-iot-edge.svg?flat&logo=docker "Docker Hub Build")](https://hub.docker.com/r/wagoautomation/azure-iot-edge/builds)

## Statistics Git Hub
[![GitHub issues](https://img.shields.io/github/issues/WAGO/azure-iot-edge.svg?flat&logo=github "GitHub issues")](https://github.com/WAGO/azure-iot-edge/issues)
[![GitHub stars](https://img.shields.io/github/stars/WAGO/azure-iot-edge.svg?flat&logo=github "GitHub stars")](https://github.com/WAGO/azure-iot-edge/stargazers)

# How to setup Azure Iot Edge on Wago Device

## Prerequisites for tutorial
- Preinstalled SSH Client (e.g. https://www.putty.org/)
- Wago Device e.g. PFC200 G2 or Wago Touch Panel with minimal Firmware 12
  - Firmware you can find here: https://github.com/WAGO/pfc-firmware
  - Docker IPKG you can find here: https://github.com/WAGO/docker-ipk
- Microsoft Azure Account 
 

## Create an Iot-Hub, add iot edge device and deviceDeploy your first IoT Edge Module: 
https://docs.microsoft.com/de-de/azure/iot-edge/quickstart-linux

Please go through the following points:
- Create an IoT Hub.
- Register an IoT Edge device to your IoT hub.
- The section <span style="color:yellow;"> <strong>"Configure your IoT Edge device" </strong></span> can be completely ignored.
- Remotely deploy a SimulatedTemperatureSensor module to an IoT Edge device.


> <span style="color:red;"> Attention: </span> To prevent port <strong>"443"</strong> clashing of <strong>"edgeHub"</strong> container and of Wago Webserver, it is absolutely necessary to change the <strong>"HostBindings"</strong>.   You can use any free host ports.

<br>
<div style="text-align: center">
<img src="images/advanceEdgeSettings.png"
     alt="AdvanceEdgeSettings"/>
</div>

## Wago Device Login
Start SSH Client e.g. Putty 
 ```bash
login as `root`
password `wago`
 ```
## Check docker installation

```bash
docker info
 ```

## Start azure iot edge runtime container. 
 ```bash
  docker run \
    -it \
    --net="host" \
    --name azure-iot-edge-runtime \
    -v //var//run//docker.sock://var//run//docker.sock \
    -v /etc/os-release:/etc/os-release \
    -e IOT_DEVICE_CONNSTR="MY_IOT_HUB_DEVICE_CONNSTR" \
    -e IOT_DEVICE_HOST_IP="MY_WAGO_DEVICE_IPADDRESS" \
    wagoautomation/azure-iot-edge
  ```

After the container start, all deployments defined in Microsoft Azure are automatically downloaded and started. 
<br>This may take a few minutes.
<br>With the Docker commands you can track the provisioning process. 
```bash
docker images 
docker ps
docker logs 
```

After all containers have been started, the following Docker command should return the following:
```bash
docker ps --format "table {{.Image}}\t {{.Status}}\t{{.Names}}"
```

<br>
<div style="text-align: center">
<img src="images/docker_ps_format.png"
     alt="AdvanceEdgeSettings"/>
</div>


The <strong>"SimulatedTemperatureSensor"</strong> module sends <strong>"500"</strong> simulation messages to your Iot Hub. The telemetry data can be displayed e.g. with a Visual Studio Code extension. (see: https://marketplace.visualstudio.com/items?itemName=vsciot-vscode.azure-iot-toolkit)

<br><br>
Finally, Wago device is ready for azure iot edge module deployment! <br>
Happy IoTing!

## Azure IoT Edge Modbus Module

You need a running Modbus Slave (Server) e.g. Wago Device or Modbus slave Simulator  

How to deploy microsoft modbus ingestion module see here: 
https://github.com/Azure/iot-edge-modbus


## Develop a C# IoT Edge module

How to develop your own azure iot edge module see here: 
https://docs.microsoft.com/en-us/azure/iot-edge/tutorial-csharp-module
<br><br>

## Get prebuild docker azure-iot-edge-runtime image
https://hub.docker.com/r/wagoautomation/azure-iot-edge

## How to build an docker azure-iot-edge-runtime image

### Build docker azure-iot-edge-runtime image on wago device
- Clone the GitHub Repository.
- Copy the folder "build-context" to Wago device. 
  - (for this you can use WinSCP or any Ftp client) 
- Start SSH Client e.g. Putty  and login.
 ```bash
login as `root`
password `wago`
 ```
- Then change to the directory "build-context".
- Set executeable flags to iot-edge-starter binary. ( necessary when transferring files from Windows PC )
```bash
chmod +x resources/iot-edge-starter
```
- Finally execute following docker command. 

```bash
docker build -t my-azure-iot-edge .
```

### Build docker azure-iot-edge-runtime image on linux pc
To build ARM images you need QEMU ARM Emulator installed see (https://www.qemu.org/) 
The easiest way to get QEMU is :
```bash
docker run --rm --privileged multiarch/qemu-user-static:register --reset
```
For more information see: https://hub.docker.com/r/multiarch/qemu-user-static/

- Clone the GitHub Repository.
- Open directory "build-context" with linux terminal.
- Finally execute following docker command. 

```bash
docker build -t my-azure-iot-edge .
```


