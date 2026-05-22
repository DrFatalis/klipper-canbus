# klipper-canbus

Docker image ready to be used here:

https://hub.docker.com/repository/docker/drfatalis/klipper-canbus/general

# Firmware already compiled for octopus with STM32F446ZET6 and ebb36/42
Klipper at /opt/klipper/firmware_out --> board_klipper.bin  ebb_klipper.bin

Katapult as /opt/katapult/firmware_out --> board_katapult.bin  ebb_katapult.bin

## Flash with can if already configured
  Check the official katapult github here: https://github.com/Arksine/katapult
  ## Board
  cd /opt/katapult/
  ./scripts/flash_can.py --interface can-mercury --uuid fa05df1c74ce -f /opt/klipper/firmware_out/board.klipper.bin

  ## EBB
  ./scripts/flash_can.py --interface can-mercury --uuid d10ef1332c72 -f /opt/klipper/firmware_out/ebb.klipper.bin

# Klipper flashing

#Open container terminal
docker exec -it -u0 containerName /bin/bash

apt install make

make menuconfig
