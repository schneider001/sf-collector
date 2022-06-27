#
# Copyright (C) 2019 IBM Corporation.
#
# Authors:
# Frederico Araujo <frederico.araujo@ibm.com>
# Teryl Taylor <terylt@ibm.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

include makefile.manifest.inc
include makefile.env.inc

.PHONY: all
all: modules sysporter

.PHONY: modules
modules:
	cd modules && make

.PHONY: sysporter
sysporter:
	cd src && make

.PHONY: install
install:
	cd modules && make install
	cd src && make install

.PHONY: uninstall
uninstall:
	cd src && make uninstall
	cd modules && make uninstall

.PHONY: package
package:
	docker run --rm --entrypoint=/bin/bash \
		-v $(shell pwd)/scripts:$(INSTALL_PATH)/scripts \
		-v $(shell pwd)/modules/dkms:$(INSTALL_PATH)/modules/src/dkms \
		-v $(shell pwd)/LICENSE.md:$(INSTALL_PATH)/LICENSE.md \
		-v $(shell pwd)/README.md:$(INSTALL_PATH)/README.md \
		sysflowtelemetry/sf-collector:${SYSFLOW_VERSION} -- $(INSTALL_PATH)/scripts/cpack/prepackage.sh
	cd scripts/cpack && export SYSFLOW_VERSION=$(SYSFLOW_VERSION) && cpack --config ./CPackConfig.cmake

.PHONY: clean
clean:
	cd src && make clean
	cd modules && make clean
	cd scripts/cpack && ./clean.sh

.PHONY: docker-build
docker-build:
	( DOCKER_BUILDKIT=1 docker build --build-arg UBI_VER=${UBI_VERSION} --build-arg FALCO_VER=${FALCO_VERSION} --build-arg FALCO_LIBS_VER=${FALCO_LIBS_VERSION} --target runtime -t sysflowtelemetry/sf-collector:${SYSFLOW_VERSION} -f Dockerfile . )

.PHONY: docker-testing-build
docker-testing-build:
	( DOCKER_BUILDKIT=1 docker build --build-arg UBI_VER=${UBI_VERSION} --build-arg FALCO_VER=${FALCO_VERSION} --build-arg FALCO_LIBS_VER=${FALCO_LIBS_VERSION} --target testing -t sysflowtelemetry/testing:${SYSFLOW_VERSION} -f Dockerfile . )

.PHONY: docker-test
docker-test:
	docker run --rm --name sf-test -v $(shell pwd)/tests:/usr/local/sysflow/tests -e INTERVAL=300 -e EXPORTER_ID=tests -e OUTPUT=/mnt/data/ sysflowtelemetry/testing:${SYSFLOW_VERSION} tests/tests.bats

.PHONY: docker-baseline-tests
docker-baseline-tests:
	docker run --rm --name sf-test -v $(shell pwd)/logs:/tmp -v $(shell pwd)/tests:/usr/local/sysflow/tests -e INTERVAL=300 -e EXPORTER_ID=tests -e OUTPUT=/mnt/data/ sysflowtelemetry/testing:${SYSFLOW_VERSION} tests/baseline.bats

.PHONY: docker-base-build
docker-base-build:
	docker pull sysflowtelemetry/ubi:base-${FALCO_LIBS_VERSION}-${FALCO_VERSION}-${UBI_VERSION} &> /dev/null || true
	( DOCKER_BUILDKIT=1 docker build --secret id=rhuser,src=$(shell pwd)/scripts/build/rhuser --secret id=rhpassword,src=$(shell pwd)/scripts/build/rhpassword --build-arg UBI_VER=${UBI_VERSION} --target base -t sysflowtelemetry/ubi:base-${FALCO_LIBS_VERSION}-${FALCO_VERSION}-${UBI_VERSION} -f Dockerfile.ubi.amd64 . )

.PHONY: docker-mods-build
docker-mods-build:
	docker pull sysflowtelemetry/ubi:base-${FALCO_LIBS_VERSION}-${FALCO_VERSION}-${UBI_VERSION} &> /dev/null || true
	( DOCKER_BUILDKIT=1 docker build --cache-from sysflowtelemetry/ubi:base-${FALCO_LIBS_VERSION}-${FALCO_VERSION}-${UBI_VERSION} --secret id=rhuser,src=$(shell pwd)/scripts/build/rhuser --secret id=rhpassword,src=$(shell pwd)/scripts/build/rhpassword --build-arg UBI_VER=${UBI_VERSION} --target mods -t sysflowtelemetry/ubi:mods-${FALCO_LIBS_VERSION}-${FALCO_VERSION}-${UBI_VERSION} -f Dockerfile.ubi.amd64 . )

.PHONY : help
help:
	@echo "The following are some of the valid targets for this Makefile:"
	@echo "... all (the default if no target is provided)"
	@echo "... clean"
	@echo "... modules"
	@echo "... sysporter"
	@echo "... package"
	@echo "... install"
	@echo "... uninstall"
	@echo "... docker-runtime-build"
	@echo "... docker-testing-build"
	@echo "... docker-base-build"i
	@echo "... docker-mods-build"
	@echo "... docker-test"
	@echo "... docker-baseline-tests"
