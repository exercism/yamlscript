# Tests

Testing Exercism exercise solutions written in YAMLScript is extremely easy.
Easy to run and easy to understand.

You just run `make test` in the exercise directory.

The first time you run `make test` all of the tests will fail, simply because
you haven't written any code to solve the tests yet.

The normal exercise development process is to start with `make test` and then
concentrate on one test at a time, writing code to make that test pass.
When all the tests pass, you're done!

As a bonus, running `make test` will also make sure that the correct version of
the `ys` YAMLScript interpreter (the one required by the current exercise) is
installed in the correct place (in `/path/to/exercism/yamlscript/.local/`).
That means you don't have to even install `ys` beforehand to get started!


## Layout of an Exercise Directory

If you are working on an exercise called `the-great-exercise`, then
`configlet download --exercise=the-great-exercise --track=yamlscript` will
create the directory `/path/to/exercism/yamlscript/the-great-exercise`.

Inside this directory, the test file will be named `the-great-exercise-test.ys`
and the solution program file will be named `the-great-exercise.ys`.
There will also be a `README.md` file with the exercise description and a
`HELP.md` file with some helpful information if you get stuck.

There will be two files for `make`: `Makefile` and `GNUmakefile`.
This is to make (npi) sure that you are using GNU `make` to run the tests and
not some other `make` command that might be installed on your system.
The `GNUmakefile` is the real one and GNU `make` will always prefer it over
`Makefile`.
Other `make` commands will use the `Makefile` which should error with a message
telling you to use GNU `make`!


## Anatomy of a Test File

YAMLScript tests are written in YAMLScript of course!
Given that YAMLScript is YAML and YAML is data, the tests are basically just
data.

Here is an example of a simple test file.
It's actually the first 3 tests from the `acronym` exercise. :-)

```yaml
#!/usr/bin/env ys-0

require ys::taptest: :all

use: acronym

test::
- name: Basic
  code: abbreviate('Portable Network Graphics')
  want: PNG

- name: Lowercase words
  code: abbreviate('Ruby on Rails')
  want: ROR

- name: Punctuation
  code: abbreviate('First In, First Out')
  want: FIFO

done: 3
```

The first line is a shebang line that tells the `prove` command (run by the
Makefile) to use the YAMLScript `ys` interpreter to run the tests instead of
`perl` which is the default for `prove`.

The second line is a `require` statement that loads YAMLScript's `ys::taptest`
[TAP](https://testanything.org) testing library.

> Note: TAP is a simple text-based interface between test scripts and test
> harnesses and `prove` is the standard harness for running TAP tests in Perl.
> Since Perl is so ubiquitous, using TAP and `prove` ends up being a very good
> choice for test suites in many languages (including YAMLScript).

The `use` statement loads the `acronym.ys` solution program so that this test
file is testing.

All of our tests are in a YAML sequence under the `test` key.

The last line `done:` is required and tells the test harness that all the tests
actually ran.
The number (which is optional) is the number of tests we expected to run.

Each test (under the `test` key) is a mapping with these key/value pairs:

* `name:` - The test label which is printed by `prove -v`.
* `code:` - The YAMLScript code to run.
  This code will call some function in the solution program we are working on.
* `what:` - For tests that expect an error to occur, the value is `error`.
  For normal tests, the pair is not present.
* `want:` - The expected result of the test.
  This is a YAML value and might be a string, number, boolean, sequence or map.
  If `what:` is `error`, then this value is the expected error message.
* `SKIP:` - Set this to `true` to skip running that test.
* `ONLY:` - Set this to `true` to only run that test.
  If you have more than one `ONLY:` test, each of them will be run.

That should be everything you need to know to do test driven development in
YAMLScript for Exercism exercises!

The `ys::taptest` library has other features that you can use to write more
complex tests, but the Exercism tests have already been written for you.
To learn more about the `ys::taptest` library, check out the [documentation](
https://yamlscript.org/doc/ys-taptest).


<!-- Keep this comment:

  This document should describe everything related to running tests in the
  track.

  If your track uses skipped tests, this document can explain why that is used
  and how to unskip tests.

  This document can also link to the testing framework documentation.

  The contents of this document are displayed on the track's documentation
  page at `https://exercism.org/docs/tracks/yamlscript/tests`.

  See https://exercism.org/docs/building/tracks/docs for more information. -->
