IMAGE_TAG_PREFIX := blingblingdev
HEAD := $(shell git rev-parse HEAD)
BRANCH := $(shell git rev-parse --abbrev-ref HEAD)

.PHONY: hubble replicator

# Pattern rule to capture target-specific values
# The % symbol matches any target name
IMAGE_TAG = $(IMAGE_TAG_PREFIX)/$@:$(BRANCH)-$(HEAD)

hubble replicator:
	docker build -f Dockerfile.$@ . -t $(IMAGE_TAG) && \
	docker push $(IMAGE_TAG)

.PHONY: help
help:
	@echo ''
	@echo 'Usage:'
	@echo ' make [target]'
	@echo ''
	@echo 'Targets:'
	@awk '/^[a-zA-Z\-\_0-9]+:/ { \
		helpMessage = match(lastLine, /^# (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")-1); \
			helpMessage = substr(lastLine, RSTART + 2, RLENGTH); \
			printf "\033[36m%-22s\033[0m %s\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help
