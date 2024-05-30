IMAGE_NAME := mdeous/pkgbuilder
IMAGE_TAG := latest

.PHONY: all build clean rebuild help

all: build

build: ## Build image
	@docker build --load --pull --cache-from "$(IMAGE_NAME):latest" -t "$(IMAGE_NAME):$(IMAGE_TAG)" .

clean: ## Delete built1 image
	@docker image rm "$(IMAGE_NAME):$(IMAGE_TAG)"

rebuild: clean build ## Delete and rebuild image

help: ## Display this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'
