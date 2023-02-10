SHELL := /bin/bash

all: image

.PHONY: compose
compose:
	./create-compose-file.sh > docker-compose.yml

.PHONY: image
image: compose
	./build.sh
