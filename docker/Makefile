# insert a brief description here
#
# This file is part of the 'Git Actions' (GA) project.
#
# Copyright © 2026, Giampiero Gabbiani <giampiero@gabbiani.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

IMAGE		= git-actions
# depending on the installed docker engine (docker vs podman) the image removal command could differ
REMOVE_CMD	= $(shell file $$(which docker) | (grep ELF >&/dev/null && echo 'docker rmi &>/dev/null' || echo 'docker rmi --ignore'))
# DOCKER_RUN gets '-it' options only if the current bash has tty attached to stdin
# UNUSED
RUN_CMD		= docker run -v $(PRJ_ROOT):/import:Z $(if $(patsubst not a tty,,$(shell tty)),-it) --rm
BUILD_CMD	= docker build

.DEFAULT_GOAL := help

all: fedora	## Build images in all the target platforms

clean: ## Clean all local Docker images
	$(call aggregate-prologue)
	$(REMOVE_CMD) $(IMAGE):fedora || true
	$(call aggregate-epilogue)

.build:
	$(call target-prologue)
	cd $(DISTRO) && cp -a \
		$(BIN)/entry-point.sh \
		$(BIN)/functions.sh \
		$(BIN)/make-picture.py \
		$(BIN)/ofl.py \
		app/ \
	&& $(BUILD_CMD) -t $(IMAGE):$(DISTRO) .
	$(call target-epilogue-success)

fedora: DISTRO=fedora
fedora: .build	## Builds a Fedora based image

help: ## Shows this help
	@grep -Eh '^[a-zA-Z0-9_/%. -]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
