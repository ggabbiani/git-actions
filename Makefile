# General project build
#
# This file is part of the 'Git Actions' (GA) project.
#
# Copyright © 2026, Giampiero Gabbiani <giampiero@gabbiani.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# 'eager' variables mostly related to the project path structure
export PRJ_ROOT			:= $(realpath $(CURDIR))
export BIN					:= $(PRJ_ROOT)/bin
export FUNCTIONS		:= $(CURDIR)/functions.mk
export SHELL				:= /bin/bash
export COMMA				:= ,

include $(FUNCTIONS)
MAKEFLAGS += -s

.DEFAULT_GOAL := help

all: docker/all	## General build

clean: docker/clean

# check: ## preliminary checks for local builds
# ifndef VIRTUAL_ENV
#   $(call msg-error,Python Virtual Environment not active: type 'source .venv/bin/activate')
# endif

docker/%: ALWAYS ## type `make -s docker/help`
	$(call make_sub)

# fake target forcing pattern rules that cannot be '.PHONY'
ALWAYS:

help: ## Shows this help
	@grep -Eh '^[a-zA-Z0-9_/%. -]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
