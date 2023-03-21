SHELL := /bin/bash

BASE_PROJECTS := \
	cuda-with-prereqs \
	cuda-with-prereqs-and-tensorrt \
	mini-cuda-base \
	mini-cuda-with-prereqs

ESRGAN_PROJECTS := \
	real-esrgan

GFPGAN_PROJECTS := \
	gfpgan

STABLE_DIFFUSION_PROJECTS := \
	basujindal-stable-diffusion \
	compvis-stable-diffusion \
	invokeai \
	invokeai-xformers

TRAINER_PROJECTS := \
	kohya_ss

BASE_COMPOSE := $(addsuffix -compose, $(BASE_PROJECTS))
BASE_IMAGES := $(addsuffix -images, $(BASE_PROJECTS))

ESRGAN_COMPOSE := $(addsuffix -compose, $(ESRGAN_PROJECTS))
ESRGAN_IMAGES := $(addsuffix -images, $(ESRGAN_PROJECTS))

GFPGAN_COMPOSE := $(addsuffix -compose, $(GFPGAN_PROJECTS))
GFPGAN_IMAGES := $(addsuffix -images, $(GFPGAN_PROJECTS))

STABLE_DIFFUSION_COMPOSE := $(addsuffix -compose, $(STABLE_DIFFUSION_PROJECTS))
STABLE_DIFFUSION_IMAGES := $(addsuffix -images, $(STABLE_DIFFUSION_PROJECTS))

TRAINER_COMPOSE := $(addsuffix -compose, $(TRAINER_PROJECTS))
TRAINER_IMAGES := $(addsuffix -images, $(TRAINER_PROJECTS))

ALL_COMPOSE := \
	$(BASE_COMPOSE) \
	$(ESRGAN_COMPOSE) \
	$(GFPGAN_COMPOSE) \
	$(STABLE_DIFFUSION_COMPOSE) \
	$(TRAINER_COMPOSE)
ALL_IMAGES := \
	$(BASE_IMAGES) \
	$(ESRGAN_IMAGES) \
	$(GFPGAN_IMAGES) \
	$(STABLE_DIFFUSION_IMAGES) \
	$(TRAINER_IMAGES)

.PHONY: all
all: all-images

# Docker compose files
.PHONY: all-compose
all-compose: $(ALL_COMPOSE)

#.PHONY: $(ALL_COMPOSE)
%-compose: %
	${MAKE} -C $</ compose

# Docker images
.PHONY: all-images
all-images: $(ALL_IMAGES)

#.PHONY: $(ALL_IMAGES)
%-images: %
	${MAKE} -C $</ image

# Scripts
.PHONY: script-permissions
script-permissions:
	find . -name "*.sh" -exec git update-index --chmod=-x {} \;
	find . \( \
	  -name "build.sh" \
	  -o \
	  -name "create-compose-file.sh" \
          -o \
	  -name "create-container.sh" \
	  \) -exec git update-index --chmod=+x {} \;

.PHONY: clean
clean:
	@find . \( \
	  -name .nopublish \
	  -o \
	  -name "log.*" \
          \) -exec rm -v {} \;

.PHONY: veryclean
veryclean: clean
	@find . \( \
          -name .*.md5 \
	  -o \
          -name .prevdigest \
	  -o \
          -name .previd \
          \) -exec rm -v {} \;
