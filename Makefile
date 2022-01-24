IMAGE_TAG := $(IMAGE_TAG)
IMAGE := artha/android-sdk-image

build:
	docker build -t $(IMAGE) .