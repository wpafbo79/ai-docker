all: base-images esrgan-images gfpgan-images stable-diffusion-images


# Groups
.PHONY: base-images
base-images: mini-cuda

.PHONY: esrgan-images
esrgan-images: real-esrgan

.PHONY: gfpgan-images
gfpgan-images: gfpgan

.PHONY: stable-diffusion-images
stable-diffusion-images: basujindal-stable-diffusion compvis-stable-diffusion invokeai


# Images
.PHONY: basujindal-stable-diffusion
basujindal-stable-diffusion:
	${MAKE} -C basujindal-stable-diffusion/

.PHONY: compvis-stable-diffusion
compvis-stable-diffusion:
	${MAKE} -C compvis-stable-diffusion/

.PHONY: gfpgan
gfpgan:
	${MAKE} -C gfpgan/

.PHONY: invokeai
invokeai:
	${MAKE} -C invokeai/

.PHONY: mini-cuda
mini-cuda:
	${MAKE} -C mini-cuda/

.PHONY: real-esrgan
real-esrgan:
	${MAKE} -C real-esrgan/
