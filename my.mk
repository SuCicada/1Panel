include Makefile
include .env.make
clean:
	rm -rf $(BUILD_PATH)

build:
	cd $(SERVER_PATH) \
    && GOOS=linux GOARCH=amd64 $(GOBUILD) -trimpath -ldflags '-s -w' -v -o $(BUILD_PATH)/$(APP_NAME) $(MAIN)

.PHONY: upload build
build-all: build_frontend build
upload:
	$(call upload_root, $(BUILD_PATH)/$(APP_NAME), /usr/local/bin/1panel)
	$(call ssh_root, 1pctl restart )

deploy: build-all upload

