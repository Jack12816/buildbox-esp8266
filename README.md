![BuildBox ESP8266](docs/logo-project.png)

This is a Docker container for building C/C++ firmwares for the ESP8266.
The ESP8266 (Xtensa RISC) processor is supported.

- [Quick Start](#quick-start)
- [Image Building](#image-building)

## Quickstart

To build a project with the Xtensa toolchain run the container like this:

```bash
$ docker run --rm -v `pwd`:/share -w /share \
    jack12816/buildbox-esp8266 make build
```

The command **make build** is just an example and must be replaced with
your own build command.

The Xtensa toolchain includes these binaries:
```xtensa-lx106-elf-addr2line xtensa-lx106-elf-ar xtensa-lx106-elf-as
xtensa-lx106-elf-c++ xtensa-lx106-elf-c++filt xtensa-lx106-elf-cc
xtensa-lx106-elf-cpp xtensa-lx106-elf-ct-ng.config xtensa-lx106-elf-elfedit
xtensa-lx106-elf-g++ xtensa-lx106-elf-gcc xtensa-lx106-elf-gcc-4.8.2
xtensa-lx106-elf-gcc-ar xtensa-lx106-elf-gcc-nm xtensa-lx106-elf-gcc-ranlib
xtensa-lx106-elf-gcov xtensa-lx106-elf-gdb xtensa-lx106-elf-gprof
xtensa-lx106-elf-ld xtensa-lx106-elf-ld.bfd xtensa-lx106-elf-nm
xtensa-lx106-elf-objcopy xtensa-lx106-elf-objdump xtensa-lx106-elf-ranlib
xtensa-lx106-elf-readelf xtensa-lx106-elf-size xtensa-lx106-elf-strings
xtensa-lx106-elf-strip```

## Image Building

Just clone this git repository and run `make`. It will show up a complete
documentation of all available commands. The default workflow is the following:

    build -> release -> publish

If you expecting any issues while testing the newly built image after release
run `make clean` and start over. All commands are idempotent and can be
executed multiple times with the same result. (Just keep in mind that the
release process will always increase the version number)
