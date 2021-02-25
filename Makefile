# 项目的一些参数放在这里
APP_NAME = Greeter
SOURCE_FILE_DIR = ./handler/hello
BUILD_DIR = $(shell pwd)/build

# go 源文件参数
GOFILES := $(shell find . -name "*.go" | grep -v vendor)
TESTFILES := $(shell find . -name "*_test.go" | grep -v vendor)
GOPACKAGES ?= $(shell go list ./...)

##@ Golang

GO_MAJOR_VERSION= $(shell go version | cut -c 14- | cut -d' ' -f1 | cut -d'.' -f1)
GO_MINOR_VERSION= $(shell go version | cut -c 14- | cut -d' ' -f1 | cut -d'.' -f2)
MINIMUM_SUPPORTED_GO_MAJOR_VERSION= 1
MINIMUM_SUPPORTED_GO_MINOR_VERSION= 13
GO_VERSION_VALIDATION_ERR_MSG = Golang version is not supported, please update to at least $(MINIMUM_SUPPORTED_GO_MAJOR_VERSION).$(MINIMUM_SUPPORTED_GO_MINOR_VERSION)

.PHONY: validate-go-version
validate-go-version: ## go 版本检测
	@if [ $(GO_MAJOR_VERSION) -gt $(MINIMUM_SUPPORTED_GO_MAJOR_VERSION) ]; then \
		exit 0 ;\
	elif [ $(GO_MAJOR_VERSION) -lt $(MINIMUM_SUPPORTED_GO_MAJOR_VERSION) ]; then \
		echo '$(GO_VERSION_VALIDATION_ERR_MSG)';\
		exit 1; \
	elif [ $(GO_MINOR_VERSION) -lt $(MINIMUM_SUPPORTED_GO_MINOR_VERSION) ] ; then \
		echo '$(GO_VERSION_VALIDATION_ERR_MSG)';\
		exit 1; \
	fi

.PHONY: fmt
fmt: ## 格式化代码
	@echo "---- Format Golang Code ----"
	gofmt -w $(GOFILES)
	@echo "---- Format Golang Code Successfully ----\n"

.PHONY: fmt-check
fmt-check: ## 代码规范检查
	@echo "---- Check Golang Code In Good Format ----"
ifneq ($(strip $(shell git status --porcelain 2>/dev/null | grep -v bindata.go | grep -v ??)),)
	git diff --exit-code
endif
	@echo "---- Check Golang Code In Good Format Successfully ----\n"

.PHONY: vet
vet: validate-go-version ## 代码的静态错误检查
	@echo "---- Initialize Go Vet ----"
	go vet $(GOPACKAGES)
	@echo "---- Go Vet Successfully ----\n"

.PHONY: lint
lint:
	@echo "---- Initialize Go lint----"
	@hash golint > /dev/null 2>&1; if [ $$? -ne 0 ]; then \
		$(GO) get -u golang.org/x/lint/golint; \
	fi
	for PKG in $(GOPACKAGES); do golint -set_exit_status $$PKG || exit 1; done;
	@echo "---- Go lint Successfully ----\n"

.PHONY: misspell
misspell:
	@echo "---- Initialize word misspell ----"
	@hash misspell > /dev/null 2>&1; if [ $$? -ne 0 ]; then \
		go get -u github.com/client9/misspell/cmd/misspell; \
	fi
	misspell -w $(GOFILES)
	@echo "---- Word misspell Successfully ----\n"

misspell-check:
	@echo "---- Initialize word misspell-check ----"
	@hash misspell > /dev/null 2>&1; if [ $$? -ne 0 ]; then \
		go get -u github.com/client9/misspell/cmd/misspell; \
	fi
	misspell -error $(GOFILES)
	@echo "---- Word misspell-check Successfully ----\n"

.PHONY: go-tools
go-tools: ## install go tools
	@echo "---- install Go tools ----"
	go install golang.org/x/lint/golint; \
	go install github.com/client9/misspell/cmd/misspell;
	@echo "---- Go tools install Successfully ----\n"

.PHONY: build
build: clean
	@echo "---- Building app ----"
	go build -o $(BUILD_DIR)/$(APP_NAME) $(SOURCE_FILE_DIR)/*.go
	@echo "---- Build app Successfully ----\n"

.PHONY: clean
clean:
	@rm -rf $(BUILD_DIR)/*

.PHONY: test
test: fmt-check ## unit test
	@echo "---- Do Testing Framework ----"
	@for f in $(TESTFILES); do go test -count=1 -v -cover -p 1 $$f; done
	@echo "---- Successfully Tested ----\n"

docker:
	# 一个编译镜像+一个运行镜像
