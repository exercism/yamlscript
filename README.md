Exercism YAMLScript Track
=========================

[![configlet](
https://github.com/exercism/yamlscript/workflows/configlet/badge.svg)](
https://github.com/exercism/yamlscript/actions?query=workflow%3Aconfiglet)
[![tests](
https://github.com/exercism/yamlscript/workflows/test/badge.svg)](
https://github.com/exercism/yamlscript/actions?query=workflow%3Atest)

Exercism exercises in YAMLScript.


## Using Makefile Commands

Actions for this repository are all automated in the Makefile.

* `make check`
* `make test`
* `make test v=1`  # verbose
* `make test exercise=hello-world`  # Test single exercise


### YAMLScript Track Repository Testing

Run `make check` to check:

* YAML files are correct
* Shell files are correct
* Exercism is set up correctly
* Each exercise is verified
* Also runs `make test`


## Testing the YAMLScript Exercises

To test all exercises, run `make test`.

To test a single exercise, run `make test exercise=<exercise-slug>`.
