SHELL := bash

export YSPATH=$(PWD)

TEST += $(wildcard *-test.ys)


default:

.PHONY: test
test:
	prove -v $(TEST)
