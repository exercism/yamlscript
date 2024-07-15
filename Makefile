SHELL := bash

ROOT := $(shell pwd)

BIN := $(ROOT)/bin
YS := $(BIN)/ys
CFGLET := $(BIN)/configlet
SHELLCHECK := $(BIN)/shellcheck
VERIFY := $(BIN)/verify-exercises

export PATH := $(BIN):$(PATH)

GEN_FILES := \
  config.json \
  docs/config.json \
  $(shell find exercises -name config.json) \

SHELL_FILES := \
  $(BIN)/fetch-configlet \

YAML_FILES := \
  config.yaml \
  docs/config.yaml \

SHELLCHECK_VERSION := v0.10.0
SHELLCHECK_REPO := https://github.com/koalaman/shellcheck
SHELLCHECK_RELEASES := $(SHELLCHECK_REPO)/releases/download
SHELLCHECK_DIR := shellcheck-$(SHELLCHECK_VERSION)
SHELLCHECK_TAR := $(SHELLCHECK_DIR).linux.x86_64.tar.xz
SHELLCHECK_RELEASE := \
  $(SHELLCHECK_RELEASES)/$(SHELLCHECK_VERSION)/$(SHELLCHECK_TAR)

exercise :=

#------------------------------------------------------------------------------
default:

test:
	$(VERIFY) $(exercise)

check: $(YS) check-yaml check-shell check-exercism

update: $(GEN_FILES)

check-yaml: $(YAML_FILES)
	for yaml in $^; do \
	  (set -x; $(YS) -l $$yaml > /dev/null); \
	done
	@echo '*** YAML files are OK'
	@echo

check-shell: $(SHELLCHECK)
	$< $(SHELL_FILES)
	@echo '*** Shell files are OK'
	@echo

check-exercism: $(CFGLET) update
	$< lint
	@echo '*** Exercism setup is OK'
	@echo

clean:
	$(RM) -r shellcheck*

realclean: clean
	$(RM) $(CFGLET)
	$(RM) $(SHELLCHECK)
	$(RM) $(BIN)/ys*

%.json: %.yaml $(YS) Makefile
	$(YS) -l $< | jq > $@

$(YS):
	curl -s https://yamlscript.org/install | \
	  PREFIX=$(ROOT) BIN=1 bash

$(CFGLET):
	$(BIN)/fetch-configlet

ifeq (,$(wildcard $(SHELLCHECK)))
$(SHELLCHECK): $(SHELLCHECK_DIR)
	mv $</shellcheck $@
	touch $@
	$(RM) -r $<
	$(RM) $(SHELLCHECK_TAR)
endif

$(SHELLCHECK_DIR): $(SHELLCHECK_TAR)
	tar xf $<

$(SHELLCHECK_TAR):
	wget $(SHELLCHECK_RELEASE)
