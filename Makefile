SHELL := bash

ROOT := $(shell pwd)

BIN := bin

YS_VERSION := 0.1.74

YS_LOCAL := .local
YS_LOCAL_PREFIX := $(YS_LOCAL)/ys-$(YS_VERSION)
YS_LOCAL_BIN := $(YS_LOCAL_PREFIX)/bin
YS := $(YS_LOCAL_PREFIX)/bin/ys-$(YS_VERSION)
CFGLET := $(BIN)/configlet
SHELLCHECK := $(BIN)/shellcheck
VERIFY := $(BIN)/verify-exercises

ifdef EXERCISM_YAMLSCRIPT_GHA
YS := ys-$(YS_VERSION)
SHELLCHECK := shellcheck
endif

export PATH := $(ROOT)/bin:$(YS_LOCAL_BIN):$(PATH)

EXERCISE_DIRS := $(shell find exercises -name .meta | sort)
EXERCISE_DIRS := $(EXERCISE_DIRS:%/.meta=%)
EXERCISES := $(EXERCISE_DIRS:exercises/practice/%=%)

EXERCISE_MAKEFILES := $(EXERCISE_DIRS:%=%/Makefile)
EXERCISE_GNU_MAKEFILES := $(EXERCISE_DIRS:%=%/GNUmakefile)
EXERCISE_YS_MAKEFILES := $(EXERCISE_DIRS:%=%/.yamlscript/exercise.mk)
EXERCISE_META_MAKEFILES := $(EXERCISE_DIRS:%=%/.meta/Makefile)
EXERCISE_YS_INSTALLERS := $(EXERCISE_DIRS:%=%/.yamlscript/exercism-ys-installer)

a := (
b := )
EXERCISE_META_LINKS := \
  $(shell ls exercises/practice/*/.yamlscript/exercise.mk \
    | perl -pe 's{$a.*$b/$a.*/.*$b}{$$1/.meta/$$2}')

CHECKS := \
  check-yaml \
  check-shell \
  check-exercism \
  check-verify \

GEN_FILES := \
  $(EXERCISE_MAKEFILES) \
  $(EXERCISE_GNU_MAKEFILES) \
  $(EXERCISE_YS_MAKEFILES) \
  $(EXERCISE_META_MAKEFILES) \
  $(EXERCISE_META_LINKS) \
  $(EXERCISE_YS_INSTALLERS) \
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

generate-all: $(PROBLEM_REPO)
	generate-all-exercises $(slug) $(slugs)

check: $(YS) $(CHECKS)
	@echo $(LINE)

test: test-exercises
	@echo $(LINE)

test-each: update
	for d in exercises/practice/*/.meta; do make -C $$d test || exit; done

update: $(GEN_FILES)

deps: $(YS) $(CFGLET) $(SHELLCHECK)

test-exercises: $(YS) update
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
	$(RM) -r $(CLOJURE_REPO) $(PROBLEM_REPO) $(YS_LOCAL)

reset:
	git checkout -- config.*
	git status -- exercises | grep exercises | xargs rm -fr

exercises/practice/%/GNUmakefile: common/exercise.mk
	cp -p $< $@

exercises/practice/%/GNUmakefile: common/makefile.mk
	cp -p $< $@

exercises/practice/%/.yamlscript/exercise.mk: common/exercise-extra.mk
	mkdir -p $$(dirname $@)
	cp -p $< $@

exercises/practice/%/.meta/Makefile: common/exercise-meta.mk
	cp -p $< $@

exercises/practice/%/.meta/.yamlscript/exercise.mk: ../../.yamlscript/exercise.mk
	ln -fs $@ $<

exercises/practice/%/.yamlscript/exercism-ys-installer: common/exercism-ys-installer
	mkdir -p $$(dirname $@)
	cp -p $< $@


%.json: %.yaml $(YS) Makefile
	$(YS) -l $< | jq > $@

$(PROBLEM_REPO):
	git clone $(PROBLEM_REPO_URL) $@

$(CLOJURE_REPO):
	git clone $(CLOJURE_REPO_URL) $@

$(CFGLET):
	$(BIN)/fetch-configlet


ifdef EXERCISM_YAMLSCRIPT_GHA
# Dummy rule for GHA
$(YS) shellcheck:

else
$(YS):
	curl -s https://yamlscript.org/install | \
	  BIN=1 PREFIX=$(YS_LOCAL_PREFIX) VERSION=$(YS_VERSION) bash

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
