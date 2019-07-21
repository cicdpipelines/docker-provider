provider := docker

version := $$(git describe --tags --abbrev=0)
build_date := $$(date +%Y-%m-%d\ %H:%M)
gitrev := $$(git rev-list -1 HEAD)

TEST?=$$(go list ./... |grep -v 'vendor')
GOFMT_FILES?=$$(find . -name '*.go' |grep -v vendor)

default: tools build package e2e 

tools:
	go get -u github.com/mitchellh/gox
	go get -u github.com/golang/dep/cmd/dep

e2e:
	go get -u github.com/NoUseFreak/cicd
	go build -o build/${provider} cmd/${provider}/main.go
	cd ./test/fixtures/docker && cicd -v trace run

build:
	dep ensure
	gox ${version_opts} --output="build/{{.OS}}_{{.Arch}}/${provider}" ./cmd/${provider}/

package:
	$(shell rm -rf build/archive)
	$(eval UNIX_FILES := $(shell ls build | grep -v ${provider} | grep -v windows))
	$(eval WINDOWS_FILES := $(shell ls build | grep -v ${provider} | grep windows))
	@mkdir -p build/archive
	@for f in $(UNIX_FILES); do \
		echo Packaging ${provider}_$$f && \
		(cd $(shell pwd)/build/$$f && tar -czf ../archive/${provider}_$$f.tar.gz ${provider}*); \
	done
	@for f in $(WINDOWS_FILES); do \
		echo Packaging ${provider}_$$f && \
		(cd $(shell pwd)/build/$$f && zip ../archive/${provider}_$$f.zip ${provider}*); \
	done
	ls -lah build/archive/