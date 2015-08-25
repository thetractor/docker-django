ROOTDIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

django_version = $(shell echo $@ | sed "s/docker-\([^-]*\)-python.*/\1/")
python_version = $(shell echo $@ | sed "s/docker-[^-]*-python\(.*\)/\1/")

all: docker-1.7.1-python2.7 \
     docker-1.8.4-python2.7 \
     docker-1.8.4-python3.4


docker-%: DJANGO_VERSION=$(django_version)
docker-%: PYTHON_VERSION=$(python_version)
docker-%:
	@echo "\
pythonversion: $(PYTHON_VERSION)-slim\n\
djangoversion: $(DJANGO_VERSION)\
" > data$(DJANGO_VERSION).yml
	docker run \
		-v $(ROOTDIR)/Dockerfile.j2:/data/Dockerfile.j2 \
		-v $(ROOTDIR)/data$(DJANGO_VERSION).yml:/data/data.yml \
		sgillis/jinja2cli Dockerfile.j2 data.yml > Dockerfile
	docker build -t quay.io/vikingco/django:$(DJANGO_VERSION)-python$(PYTHON_VERSION) .
	@rm data$(DJANGO_VERSION).yml
	@rm Dockerfile
	docker push quay.io/vikingco/django:$(DJANGO_VERSION)-python$(PYTHON_VERSION)
