# klipper-canbus


Docker image ready to be used here:

https://hub.docker.com/repository/docker/drfatalis/klipper-canbus/general

# Firmware already compiled for octopus with STM32F446ZET6 and ebb36/42
#check /opt/klipper/firmware_out

# Klipper flashing

#Open container terminal
docker exec -it -u0 containerName /bin/bash

apt install make

make menuconfig
