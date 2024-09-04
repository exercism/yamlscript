SHELL := bash

BASE := $(shell pwd)

include .yamlscript/exercise.mk

YS_LOCAL_PREFIX := ../../../.local/ys-$(YS_VERSION)

ifeq (,$(shell [[ "$(YS_LOCAL_PREFIX)" ]] && echo ok))
YS_LOCAL_PREFIX := ../.yamlscript/ys-$(YS_VERSION)
endif

YS_LOCAL_BIN := $(YS_LOCAL_PREFIX)/bin

YS_BIN := $(YS_LOCAL_BIN)/ys-$(YS_VERSION)

TEST_FILE ?= $(wildcard *-test.ys)

export PATH := $(YS_LOCAL_BIN):$(PATH)

export YSPATH := $(BASE)


default:
	@echo " No default make rule. Try 'make test'."

test: $(YS_BIN)
	prove -v $(TEST_FILE)

$(YS_BIN):
	@echo "$$install_msg"

install-ys:
	bash .yamlscript/exercism-ys-installer $(YS_VERSION) $(MAKE)


define install_msg

This YAMLScript Exercism exercise requires the YAMLScript interpreter file:

  $(YS_BIN)

to be installed.

You can install it with:

  $(MAKE) install-ys

This should only take a few seconds and you only need to do this once.

Other exercises will use the same file.

endef

export install_msg
