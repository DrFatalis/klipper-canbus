##
## Get Klipper Source and Build venv
## Inspired from mkuf
##
FROM python:3.12-bookworm as build

RUN apt update \
 && apt install -y cmake make gcc gcc-arm-none-eabi python3 python3-pip python3-can usbutils gcc-avr python3-can \
 && apt clean

WORKDIR /opt

# Getting Klipper from Repo
RUN python -m venv venv \
 && venv/bin/pip install pyserial setuptools python-can

ARG KLIPPER_REPO=https://github.com/Klipper3d/klipper
ARG KLIPPER_VERSION=master

RUN git clone ${KLIPPER_REPO} klipper \
 && cd klipper \
 && git checkout ${KLIPPER_VERSION} \
 && rm -rf .git

RUN venv/bin/pip install -r klipper/scripts/klippy-requirements.txt \
 && venv/bin/python -m compileall klipper/klippy \
 && venv/bin/python klipper/klippy/chelper/__init__.py

RUN mkdir /opt/klipper/firmware_out

## Compile klipper for main board
COPY config.board.klipper /opt/klipper/.config
WORKDIR /opt/klipper
RUN make
RUN cp /opt/klipper/out/klipper.bin /opt/klipper/firmware_out/board_klipper.bin
RUN make clean

## Compile klipper for toolhead board
COPY config.ebb.klipper /opt/klipper/.config
WORKDIR /opt/klipper
RUN make
RUN cp /opt/klipper/out/klipper.bin /opt/klipper/firmware_out/ebb_klipper.bin 
RUN make clean

WORKDIR /opt

# Getting katapult from Repo
ARG KATAPULT_REPO=https://github.com/Arksine/katapult
ARG KATAPULT_VERSION=master

RUN git clone ${KATAPULT_REPO} katapult \
 && cd katapult \
 && git checkout ${KATAPULT_VERSION} \
 && rm -rf .git

RUN mkdir /opt/katapult/firmware_out

## Compile katapult for main board
COPY config.board.katapult /opt/katapult/.config
WORKDIR /opt/katapult
RUN make
RUN cp /opt/katapult/out/katapult.bin /opt/katapult/firmware_out/board_katapult.bin
RUN make clean

## Compile katapult for toolhead board
COPY config.ebb.katapult /opt/katapult/.config
WORKDIR /opt/katapult
RUN make
RUN cp /opt/katapult/out/katapult.bin /opt/katapult/firmware_out/ebb_katapult.bin 
RUN make clean

###
## Klippy Runtime Image
##
FROM python:3.12-slim-bookworm as run

RUN apt update \
 && apt install -y python3-can dfu-util usbutils iproute2 net-tools can-utils \
 && apt clean

RUN pip3 install python-can pyserial

WORKDIR /opt
RUN groupadd klipper --gid 1000 \
 && useradd klipper --uid 1000 --gid klipper \
 && usermod klipper --append --groups dialout \
 && usermod klipper --append --groups tty
RUN mkdir -p printer_data/run printer_data/gcodes printer_data/logs printer_data/config \
 && chown -R klipper:klipper /opt/*

COPY --chown=klipper:klipper --from=build /opt/klipper ./klipper
COPY --chown=klipper:klipper --from=build /opt/venv ./venv
COPY --chown=klipper:klipper --from=build /opt/katapult ./katapult

USER klipper
VOLUME ["/opt/printer_data/run", "/opt/printer_data/gcodes", "/opt/printer_data/logs", "/opt/printer_data/config"]
ENTRYPOINT ["/opt/venv/bin/python", "klipper/klippy/klippy.py"]
CMD ["-I", "printer_data/run/klipper.tty", "-a", "printer_data/run/klipper.sock", "printer_data/config/printer.cfg"]
