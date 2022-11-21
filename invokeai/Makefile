all: compose image

.PHONY: compose
compose:
	./create-compose-file.sh > docker-compose.yml

.PHONY: image
image:
	./build.sh
