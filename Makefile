# project parameters
APP = holdon
IMG = holdon:v1
BUILD_DIR = $(shell pwd)/build
COMMIT= $(shell git rev-parse --short HEAD)
ifndef VER
	VER = dev
endif

# go source packages and files
GOFILES := $(shell find . -name "*.go" | grep -v vendor)
TESTFILES := $(shell find . -name "*_test.go" | grep -v vendor)
GOPACKAGES := $(shell go list ./...)
SOURCEFILE := $(shell ls ./cmd)

##@ Golang

GO_MAJOR_VERSION= $(shell go version | cut -c 14- | cut -d' ' -f1 | cut -d'.' -f1)
GO_MINOR_VERSION= $(shell go version | cut -c 14- | cut -d' ' -f1 | cut -d'.' -f2)
MINIMUM_SUPPORTED_GO_MAJOR_VERSION= 1
MINIMUM_SUPPORTED_GO_MINOR_VERSION= 13
GO_VERSION_VALIDATION_ERR_MSG = Golang version is not supported, please update to at least $(MINIMUM_SUPPORTED_GO_MAJOR_VERSION).$(MINIMUM_SUPPORTED_GO_MINOR_VERSION)

.PHONY: validate-go-version
validate-go-version:
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
fmt:
	@echo "---- Format Golang Code ----"
	gofmt -w $(GOFILES)
	@echo "---- Format Golang Code Successfully ----\n"

.PHONY: fmt-check
fmt-check:
	@echo "---- Check Golang Code In Good Format ----"
ifneq ($(strip $(shell git status --porcelain 2>/dev/null | grep -v bindata.go | grep -v ??)),)
	git diff --exit-code
endif
	@echo "---- Successfully Check Golang Code In Good Format ----\n"

.PHONY: vet
vet: validate-go-version
	@echo "---- Initialize Go Vet ----"
	go vet $(GOPACKAGES)
	@echo "---- Successfully Initialize Go Vet ----\n"

.PHONY: lint
lint:
	@echo "---- Initialize Go lint ----"
	for PKG in $(GOPACKAGES); do golint -set_exit_status $$PKG || exit 1; done;
	@echo "---- Successfully Go lint ----\n"

.PHONY: misspell
misspell:
	@echo "---- Initialize word misspell ----"
	misspell -w $(GOFILES)
	@echo "---- Word misspell Successfully ----\n"

.PHONY: misspell-check
misspell-check:
	@echo "---- Initialize word misspell-check ----"
	misspell -error $(GOFILES)
	@echo "---- Word misspell-check Successfully ----\n"

.PHONY: go-tools
go-tools: ## install go tools
	@echo "---- install Go tools ----"
	go install golang.org/x/lint/golint; \
	go install github.com/client9/misspell/cmd/misspell;
	@echo "---- Go tools install Successfully ----\n"

.PHONY: build
build: validate-go-version
	@echo "---- Building APP ----"
ifdef WHAT
	./build.sh $(WHAT) $(VER) $(COMMIT)
else
	for pkg in $(SOURCEFILE); \
	do go build -ldflags "-X main.VERSION=$(VER) -X main.COMMIT=$(COMMIT)" \
		-o $(BUILD_DIR) ./cmd/$$pkg/*.go; done
endif
	@echo "---- Build app Successfully ----\n"

.PHONY: clean
clean:
	@rm -rf $(BUILD_DIR)/*

.PHONY: test
test: fmt-check ## unit test
	@echo "---- Do Testing Framework ----"
ifdef FLAG
	@for f in $(TESTFILES); do go test $(FLAG) $$f; done
else
	@for f in $(TESTFILES); do go test -count=1 -v -cover -p 1 $$f; done
endif
	@echo "---- Successfully Tested ----\n"

.PHONY: docker
docker:
	@echo "---- Docker build FOR $(IMG) ----"
	docker build --build-arg APP=$(APP) -t $(IMG) . #&& docker push $(IMG)
	@echo "---- Successfullu build $(IMG) ----"
