# klipper-canbus

Docker image ready to be used here:

https://hub.docker.com/repository/docker/drfatalis/klipper-canbus/general

# Firmware already compiled for Octopus Pro v1.1 with STM32H723ZET6 and ebb36/42
Klipper at /opt/klipper/firmware_out --> board_klipper.bin  ebb_klipper.bin

Katapult as /opt/katapult/firmware_out --> board_katapult.bin  ebb_katapult.bin

# Katapult needs to be configured on the board
Check the official katapult github here: https://github.com/Arksine/katapult

To perform the katapult flash, disconnect any things from the board (sd card included). 
Put the octopus pro v1.1 to DFU mode with the jumper connected, and make sure that the USB power supply is there. 
Then, use something like WinSCP to connect to you docker host host and retreive board.katapult.bin. 
Finally, use STM32Programmer to open that file, erase the whole octopus chip and flash the new bootloader.

## Flash klipper if no can yet configured
  Connect to your docker host, and enter the container: 

  docker exec -it -u0 container_name bash

  Then execute the command to flash the octopus board
  
  python3 /opt/katapult/scripts/flashtool.py -f /opt/klipper/firmware_out/board.klipper.bin -d /dev/serial/by-id/usb-katapult_your_board_id

  To find the can uuid, you might have to use can0 and not can-mercury. As i have multiple printer on the same host, i configured custom names: 

  /opt/klippy-env/bin/python /opt/klipper/scripts/canbus_query.py can-mercury


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
