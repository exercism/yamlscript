SHELL := bash

ROOT := $(shell pwd)

BIN := $(ROOT)/bin
YS := $(BIN)/ys
CFGLET := $(BIN)/configlet
SHELLCHECK := $(BIN)/shellcheck
VERIFY := $(BIN)/verify-exercises

export PATH := $(BIN):$(PATH)

EXERCISE_DIRS := $(shell find exercises -name .meta)
EXERCISE_DIRS := $(EXERCISE_DIRS:%/.meta=%)
EXERCISES := $(EXERCISE_DIRS:exercises/practice/%=%)
EXERCISE_CONFIGS := $(EXERCISE_DIRS:%=%/.meta/config.json)
EXERCISE_MAKEFILES := $(EXERCISE_DIRS:%=%/Makefile)

CHECKS := \
  check-yaml \
  check-shell \
  check-exercism \
  check-verify \
  test-exercises \

GEN_FILES := \
  $(EXERCISE_MAKEFILES) \
  config.json \
  docs/config.json \
  $(EXERCISE_CONFIGS) \

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

LINE := $(shell printf '%.0s-' {1..80})

exercise ?=
v ?=

ifeq (,$(exercise))
exercise-name := all exercises
override exercise := exercises/practice/*/.meta/*-test.ys
else
exercise-name := $(exercise)
override exercise := exercises/practice/$(exercise)/.meta/*-test.ys
endif


#------------------------------------------------------------------------------
default:

check: $(YS) $(CHECKS)
	@echo $(LINE)

test: test-exercises
	@echo $(LINE)

test-exercises:
	@echo $(LINE)
	@echo '*** Running tests for $(exercise-name)'
	prove $(if $v,-v ,)$(exercise)
	@echo '*** All exercises test ok'

update: $(GEN_FILES)

check-yaml: $(YAML_FILES)
	@echo $(LINE)
	@echo '*** Test YAML files'
	@for yaml in $^; do \
	  (set -x; $(YS) -l $$yaml > /dev/null); \
	done
	@echo '*** YAML files are OK'
	@echo

check-shell: $(SHELLCHECK)
	@echo $(LINE)
	@echo '*** Test shell script files'
	@$< $(SHELL_FILES)
	@echo '*** Shell script files are OK'
	@echo

check-exercism: $(CFGLET) update
	@echo $(LINE)
	@echo '*** Test Exercism setup'
	$< lint
	@echo '*** Exercism setup is OK'
	@echo

check-verify:
	@echo $(LINE)
	@echo '*** Test all exercises are verified'
	$(VERIFY) $(exercise)
	@echo '*** All exercises are verified OK'
	@echo

clean:
	$(RM) -r shellcheck*

realclean: clean
	$(RM) $(CFGLET)
	$(RM) $(SHELLCHECK)
	$(RM) $(BIN)/ys*

exercises/practice/%/Makefile: common/exercise.mk
	cp -p $< $@

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
