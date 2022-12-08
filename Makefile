all: all-compose all-images

# Docker Compose Groups
.PHONY: all-compose
all-compose: esrgan-compose gfpgan-compose stable-diffusion-compose

.PHONY: esrgan-compose
esrgan-compose: real-esrgan-compose

.PHONY: gfpgan-compose
gfpgan-compose: gfpgan-compose

.PHONY: stable-diffusion-compose
stable-diffusion-compose: basujindal-stable-diffusion-compose compvis-stable-diffusion-compose invokeai-compose

# Docker compose files
.PHONY: basujindal-stable-diffusion-compose
basujindal-stable-diffusion-compose:
	${MAKE} -C basujindal-stable-diffusion/ compose

.PHONY: compvis-stable-diffusion-compose
compvis-stable-diffusion-compose:
	${MAKE} -C compvis-stable-diffusion/ compose

.PHONY: gfpgan-compose
gfpgan-compose:
	${MAKE} -C gfpgan/ compose

.PHONY: invokeai-compose
invokeai-compose:
	${MAKE} -C invokeai/ compose

.PHONY: real-esrgan-compose
real-esrgan-compose:
	${MAKE} -C real-esrgan/ compose

# Image Groups
.PHONY: all-images
all-images: base-images esrgan-images gfpgan-images stable-diffusion-images

.PHONY: base-images
base-images: mini-cuda-image

.PHONY: esrgan-images
esrgan-images: real-esrgan-image

.PHONY: gfpgan-images
gfpgan-images: gfpgan-image

.PHONY: stable-diffusion-images
stable-diffusion-images: basujindal-stable-diffusion-image compvis-stable-diffusion-image invokeai-image

# Images
.PHONY: basujindal-stable-diffusion-image
basujindal-stable-diffusion-image:
	${MAKE} -C basujindal-stable-diffusion/ image

.PHONY: compvis-stable-diffusion-image
compvis-stable-diffusion-image:
	${MAKE} -C compvis-stable-diffusion/ image

.PHONY: gfpgan-image
gfpgan-image:
	${MAKE} -C gfpgan/ image

.PHONY: invokeai-image
invokeai-image:
	${MAKE} -C invokeai/ image

.PHONY: mini-cuda-image
mini-cuda-image:
	${MAKE} -C mini-cuda/ image

.PHONY: real-esrgan-image
real-esrgan-image:
	${MAKE} -C real-esrgan/ image

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
