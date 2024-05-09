include Makefile
include .env
clean:
	rm -rf $(BUILD_PATH)

build:
	cd $(SERVER_PATH) \
    && GOOS=linux GOARCH=amd64 $(GOBUILD) -trimpath -ldflags '-s -w' -v -o $(BUILD_PATH)/$(APP_NAME) $(MAIN)

upload: 
	$(call upload_root, $(BUILD_PATH)/$(APP_NAME), /usr/local/bin/1panel)