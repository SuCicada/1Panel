include .env.make
clean:
	rm -rf $(BUILD_PATH)

build:
	cd $(SERVER_PATH) && \
	source ~/.bashrc && gvm use system && \
	go mod tidy && \
    GOOS=linux GOARCH=amd64 $(GOBUILD) -trimpath -ldflags '-s -w' -v -o $(BUILD_PATH)/$(APP_NAME) $(MAIN)

.PHONY: upload build
build-all: build_frontend build upload
upload:
	$(call upload_root, $(BUILD_PATH)/$(APP_NAME), /usr/local/bin/1panel)
	$(call ssh_root, 1pctl restart )

deploy: build-all upload


test1:
	go version
	go env

