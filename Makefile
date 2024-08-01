SHELL := bash

ROOT := $(shell pwd)

BIN := bin

YS := $(BIN)/ys
CFGLET := $(BIN)/configlet
SHELLCHECK := $(BIN)/shellcheck
VERIFY := $(BIN)/verify-exercises

ifdef EXERCISM_YAMLSCRIPT_GHA
YS := ys
SHELLCHECK := shellcheck
endif

export PATH := $(ROOT)/bin:$(PATH)

EXERCISE_DIRS := $(shell find exercises -name .meta)
EXERCISE_DIRS := $(EXERCISE_DIRS:%/.meta=%)
EXERCISES := $(EXERCISE_DIRS:exercises/practice/%=%)
EXERCISE_MAKEFILES := $(EXERCISE_DIRS:%=%/Makefile)
a := (
b := )
EXERCISE_META_TESTS := $(shell ls -d exercises/practice/*/*-test.ys | \
                         perl -pe 's{$a.*$b/test}{$$1/.meta/test}')

CHECKS := \
  check-yaml \
  check-shell \
  check-exercism \
  check-verify \

GEN_FILES := \
  $(EXERCISE_MAKEFILES) \
  $(EXERCISE_META_TESTS) \
  config.json \

SHELL_FILES := \
  $(BIN)/fetch-configlet \
  $(BIN)/new-exercise \
  $(BIN)/verify-exercises \

YAML_FILES := \
  config.yaml \

PROBLEM_REPO := .problem
PROBLEM_REPO_URL := https://github.com/exercism/problem-specifications

CLOJURE_REPO := .clojure
CLOJURE_REPO_URL := https://github.com/exercism/clojure

SHELLCHECK_VERSION := v0.10.0
SHELLCHECK_REPO := https://github.com/koalaman/shellcheck
SHELLCHECK_RELEASES := $(SHELLCHECK_REPO)/releases/download
SHELLCHECK_DIR := shellcheck-$(SHELLCHECK_VERSION)
SHELLCHECK_TAR := $(SHELLCHECK_DIR).linux.x86_64.tar.xz
SHELLCHECK_RELEASE := \
  $(SHELLCHECK_RELEASES)/$(SHELLCHECK_VERSION)/$(SHELLCHECK_TAR)

LINE := $(shell printf '%.0s-' {1..80})

slug ?=
test ?=
v ?=

ifeq (,$(test))
test-name := all exercises
override test := exercises/practice/*/.meta/*-test.ys
else
test-name := $(test)
override test := exercises/practice/$(test)/.meta/*-test.ys
endif

export YSPATH := $(shell IFS=:; p=$aexercises/practice/*/.meta$b; \
	           echo "$${p[*]}")


#------------------------------------------------------------------------------
default:

.PHONY: new
new: $(CFGLET) $(YS) $(PROBLEM_REPO) $(CLOJURE_REPO)
ifndef slug
	$(error Please set the 'slug' variable)
endif
	@exercise=$(slug) new-exercise

generate-all:
	generate-all-exercises $(slug) $(slugs)

check: $(YS) $(CHECKS)
	@echo $(LINE)

test: test-exercises
	@echo $(LINE)

update: $(GEN_FILES)

deps: $(YS) $(CFGLET) $(SHELLCHECK)

test-exercises: $(YS)
	@echo $(LINE)
	@echo '*** Running tests for $(test-name)'
	@$(MAKE) --no-print-directory run-tests
	@echo '*** All exercises test ok'

run-tests:
	prove $(if $v,-v ,)$(test)

check-yaml: $(YS) $(YAML_FILES)
	@echo $(LINE)
	@echo '*** Test YAML files'
	@for yaml in $(YAML_FILES); do \
	  (set -x; $< -l $$yaml > /dev/null); \
	done
	@echo '*** YAML files are OK'
	@echo

check-shell: $(SHELLCHECK)
	@echo $(LINE)
	@echo '*** Test shell script files'
	$< $(SHELL_FILES)
	@echo '*** Shell script files are OK'
	@echo

check-exercism: $(CFGLET) update
	@echo $(LINE)
	@echo '*** Test Exercism setup'
	$< lint
	@echo '*** Exercism setup is OK'
	@echo

check-verify: update
	@echo $(LINE)
	@echo '*** Test all exercises are verified'
	$(VERIFY) $(slug)
	@echo '*** All exercises are verified OK'
	@echo

clean:
	$(RM) -r shellcheck*

realclean: clean
	$(RM) $(CFGLET)
	$(RM) $(SHELLCHECK)
	$(RM) $(BIN)/ys*
	$(RM) -r $(CLOJURE_REPO) $(PROBLEM_REPO)

reset:
	git checkout -- config.*
	git status -- exercises | grep exercises | xargs rm -fr

exercises/practice/%/Makefile: common/exercise.mk
	cp -p $< $@

$(EXERCISE_META_TESTS):
	( d=$$(dirname $@); f=$$(basename $@); cd $$d && ln -fs ../$$f )


%.json: %.yaml $(YS) Makefile
	$(YS) -l $< | jq > $@

$(PROBLEM_REPO):
	git clone $(PROBLEM_REPO_URL) $@

$(CLOJURE_REPO):
	git clone $(CLOJURE_REPO_URL) $@

$(CFGLET):
	$(BIN)/fetch-configlet

# Dummy rule for GHA
ys shellcheck:

ifndef EXERCISM_YAMLSCRIPT_GHA
bin/ys:
	curl -s https://yamlscript.org/install | \
	  PREFIX=$(ROOT) BIN=1 bash

ifeq (,$(wildcard $(SHELLCHECK)))
bin/shellcheck: $(SHELLCHECK_DIR)
	mv $</shellcheck $@
	touch $@
	$(RM) -r $<
	$(RM) $(SHELLCHECK_TAR)
endif

$(SHELLCHECK_DIR): $(SHELLCHECK_TAR)
	tar xf $<

$(SHELLCHECK_TAR):
	curl -sSOL $(SHELLCHECK_RELEASE)
endif
