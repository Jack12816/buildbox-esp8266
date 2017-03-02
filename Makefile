MAKEFLAGS += --warn-undefined-variables
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := all
.DELETE_ON_ERROR:
.SUFFIXES:
.PHONY:

EXIT := exit
ECHO := echo
CAT := cat
SLEEP := sleep
TEST := test
GREP := grep
CLEAR := clear
FIND := find
SORT := sort
HEAD := head
REV := rev
CUT := cut
SED := sed
CP := cp
MKDIR := mkdir
TIME := time
CURL := curl
MAKE := make
PYTHON := python
DOCKER := docker

TMP_PATH ?= tmp

CONTAINER_REGISTRY ?=
CONTAINER_REGISTRY_API ?= registry.hub.docker.com
CONTAINER_NAME ?= jack12816/buildbox-esp8266
CONTAINER_URI := $(CONTAINER_REGISTRY)$(CONTAINER_NAME)
CONTAINER_URI_DEV := $(CONTAINER_URI):dev

NEXT_VERSION_FILE := $(TMP_PATH)/.version
NEXT_VERSION = $(shell $(TEST) -f $(NEXT_VERSION_FILE) \
	&& $(CAT) $(NEXT_VERSION_FILE))

CUR_RELEASE = $(shell \
	$(CURL) -k -s 'https://$(CONTAINER_REGISTRY_API)/v1/repositories/$(CONTAINER_NAME)/tags' \
		| $(PYTHON) -m json.tool \
		| $(GREP) '^\s*"' \
		| $(SED) 's/[ "]*//g' \
		| $(CUT) -d: -f1 \
		| $(GREP) '^[0-9]\|^Resourcenotfound$$' \
		| $(SORT) -V -r \
		| $(HEAD) -n1 \
		| $(SED) 's/^Resourcenotfound$$/0.0.0/g')

all:
	# BuildBox ESP8266
	#
	# build          Build a development snapshot of the image
	# release        Release the current development snapshot of the image
	# publish        Alias the current release as latest and push the new image
	#
	# shell          You can start an individual session of the image for tests
	# clean          Clean the current development snapshot

build: clean
	# Build the Docker image
	@$(TIME) $(DOCKER) build \
		-t "$(CONTAINER_URI_DEV)" .

release: .release-ask-next-version
	# Tag the current development snapshot to the version $(NEXT_VERSION)
	@$(DOCKER) tag "$(CONTAINER_URI_DEV)" "$(CONTAINER_URI):$(NEXT_VERSION)"
	# Tag the new version as the latest
	@$(DOCKER) tag "$(CONTAINER_URI):$(NEXT_VERSION)" "$(CONTAINER_URI):latest"

publish:
	# Publish the new version on the registry
	@$(DOCKER) push "$(CONTAINER_URI):$(NEXT_VERSION)"
	# Update the `latest` tag on the registry
	@$(DOCKER) push "$(CONTAINER_URI):latest"
	# Finalize the current release process
	@$(RM) -f $(NEXT_VERSION_FILE) || true

shell:
	# Start an individual test session of the image
	@$(MKDIR) -p share
	# You can find the share mountpoint at /share
	@$(DOCKER) run --rm -it \
		-u `id -u` -v `pwd`/share:/share \
		"$(CONTAINER_URI_DEV)" bash

clean:
ifneq (,$(NEXT_VERSION))
	# Untag the unpublished version $(NEXT_VERSION)
	@$(DOCKER) rmi --force "$(CONTAINER_URI):$(NEXT_VERSION)" || true
endif
	# Untag the current `latest` tag
	@$(DOCKER) rmi --force "$(CONTAINER_URI):latest" || true
	# Clean the current development snapshot
	@$(DOCKER) rmi --force "$(CONTAINER_URI_DEV)" || true

.release-ask-next-version:
	@$(CLEAR)
	@$(MKDIR) -p $(TMP_PATH)
	@./tools/ask-next-version \
		"$(CUR_RELEASE)" "$(NEXT_VERSION_FILE)" \
		"Image: $(CONTAINER_URI)\n\n"
	@$(CLEAR)
