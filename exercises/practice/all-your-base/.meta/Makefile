SHELL := bash

BASE := $(shell pwd)

include .yamlscript/exercise.mk

YS_LOCAL_PREFIX := ../../../../.local/v$(YS_VERSION)

YS_LOCAL_BIN := $(YS_LOCAL_PREFIX)/bin

YS_BIN := $(YS_LOCAL_BIN)/ys-$(YS_VERSION)

TEST_FILE ?= $(wildcard *-test.ys)


export PATH := $(YS_LOCAL_BIN):$(PATH)

export YSPATH := $(BASE)


default:

test: $(YS_BIN)
	prove -v $(TEST_FILE)

$(YS_BIN):
	curl -s https://yamlscript.org/install | \
	  BIN=1 VERSION=$(YS_VERSION) PREFIX=$(YS_LOCAL_PREFIX) bash >/dev/null
