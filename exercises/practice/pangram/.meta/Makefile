SHELL := bash

BASE := $(shell pwd)

include .yamlscript/exercise.mk

YS_LOCAL_PREFIX := ../../../../.local/ys-$(YS_VERSION)

YS_LOCAL_BIN := $(YS_LOCAL_PREFIX)/bin

YS_BIN := $(YS_LOCAL_BIN)/ys-$(YS_VERSION)

TEST_FILE ?= $(wildcard *-test.ys)


export PATH := $(YS_LOCAL_BIN):$(PATH)

export YSPATH := $(BASE)


default:

test: $(YS_BIN)
	prove -v $(TEST_FILE)
