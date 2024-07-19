SHELL := bash

ROOT := $(shell pwd)

BIN := $(ROOT)/bin

YS := $(BIN)/ys

export PATH := $(BIN):$(PATH)

GEN_FILES := \
  config.json \


default:
	which ys

update: $(GEN_FILES)

test: test-yaml test-bash

clean:

realclean: clean
	$(RM) -f $(BIN)/ys*

%.json: %.yaml $(YS) Makefile
	ys -l $< | jq > $@

$(YS):
	curl -s https://yamlscript.org/install | \
	  PREFIX=$(ROOT) BIN=1 bash
