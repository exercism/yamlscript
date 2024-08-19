SHELL := bash

TEST :=
ifneq (,$(wildcard test))
  TEST += test/*.ys
endif
ifneq (,$(wildcard *-test.ys))
  TEST += $(wildcard *-test.ys)
endif


export YSPATH=$(PWD)

default:
	@which ys

.PHONY: test
test:
	prove -v $(TEST)
