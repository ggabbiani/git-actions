# insert a brief description here
#
# This file is part of the 'Git Actions' (GA) project.
#
# Copyright © 2026, Giampiero Gabbiani <giampiero@gabbiani.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

export PRJ_ROOT				:= $(realpath $(CURDIR))
export FUNCTIONS			:= $(CURDIR)/functions.mk
export SHELL				:= /bin/bash
export COMMA				:= ,

include $(FUNCTIONS)
MAKEFLAGS += -s

# function dependant variables
# $(info SCAD path: $(call scad-path))
export SCAD		:= $(if $(call scad-path),$(BIN)/openscad.py -m make --view axes,$(warning WARN: OpenSCAD missing))
# $(info SCAD command: $(SCAD))
export WHICH 	:= $(if $(call is-win),where,which)
export IMVER 	:= $(shell convert --version 2>&1)
export IMCMD 	:= $(if $(findstring deprecated,$(IMVER)),$(shell $(WHICH) magick 2>/dev/null),$(shell $(WHICH) convert 2>/dev/null))
export WGET		:= $(shell $(call which) $(if $(call is-mac), curl,wget))

.DEFAULT_GOAL := help

# docs uses generated test scad files, so it's important to be executed AFTER
# tests creation
all: docker/all

clean: docker/clean

check: ## preliminary checks
ifdef IMVER
	$(call msg-info,ImageMagick command found '$(IMCMD)')
else
	$(call msg-error,ImageMagick not found, please install)
endif
ifndef VIRTUAL_ENV
	$(call msg-error,Python Virtual Environment not active: type 'source .venv/bin/activate')
endif

docker/%: ALWAYS ## type `make -s docker/help`
	$(call make_sub)

# fake target forcing pattern rules that cannot be '.PHONY'
ALWAYS:

help: ## Shows this help
	@grep -Eh '^[a-zA-Z0-9_/%. -]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
