FROM base/archlinux:latest
MAINTAINER Hermann Mayer <hermann.mayer92@gmail.com>

COPY . /app
RUN chmod 755 /app/bin/*
RUN /app/bin/install

ENV PATH /opt/esptool-ck:/opt/xtensa-lx106-elf/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
