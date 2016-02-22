ROOTDIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

python_version = $(shell echo $@ | sed "s/[^-]*-python-\(.*\)/\1/")

all: build push

push: push-python-pypy-2.4.0 push-python-2.7.5 push-python-2.7.11 push-python-3.4.3 push-python-3.5.1

build: build-python-pypy-2.4.0 build-python-2.7.5 build-python-2.7.11 build-python-3.4.3 build-python-3.5.1

build-%: PYTHON_VERSION=$(python_version)
build-%:
	@echo "\
pythonversion: $(PYTHON_VERSION)\
" > data$(PYTHON_VERSION).yml
	docker run --rm \
		-v $(ROOTDIR)/Dockerfile.j2:/data/Dockerfile.j2 \
		-v $(ROOTDIR)/data$(PYTHON_VERSION).yml:/data/data.yml \
		vikingco/jinja2cli Dockerfile.j2 data.yml > Dockerfile
	docker build -t vikingco/django:$(PYTHON_VERSION) .
	@rm data$(PYTHON_VERSION).yml
	@rm Dockerfile

push-%: PYTHON_VERSION=$(python_version)
push-%:
	docker push vikingco/django:$(PYTHON_VERSION)
