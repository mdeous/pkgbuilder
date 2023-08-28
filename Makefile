IMAGE_NAME := mdeous/pkgbuilder
IMAGE_TAG := latest

.PHONY: all build clean

all: build

build:
	docker build --load --pull --cache-from "$(IMAGE_NAME):latest" -t "$(IMAGE_NAME):$(IMAGE_TAG)" .

clean:
	docker image rm "$(IMAGE_NAME):$(IMAGE_TAG)"
