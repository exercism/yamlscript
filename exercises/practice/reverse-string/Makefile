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

.PHONY: test
test:
	prove -v $(TEST)
