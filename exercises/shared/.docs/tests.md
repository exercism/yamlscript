# Tests

To test your solution simply run:

```bash
make test
```

This will run the test file `<exercise-name>-test.ys` which contains all of the
tests that you will need to pass for your solution to be correct.
You should study the test file to understand exactly what your solution needs
to do.

> Note: The first time you run `make test` it will also make sure that the
> correct version of the `ys` YAMLScript interpreter is installed in the
> correct place.

If you run `make test` before changing any files, all the tests will fail.
This is the proper and expected behavior.
The normal exercise development process is to iteratively improve your
solution, running `make test` after each change, until all the tests pass.

If you want to only run a specific test (while concentrating on that part of the
solution), you can add this key/value pair to that test:

```yaml
  ONLY: true
```

If you want to skip particular tests (while working on other parts of the
solution), you can add this key/value pair to those tests:

```yaml
  SKIP: true
```


## Testing Prerequisites

YAMLScript currently runs on MacOS and Linux.

Your computer will need to have the following very common commands installed:

* `bash` - You can run the tests under any shell, but `bash` must be available.
* `make` - You must use GNU `make` to run the tests.
  In some environments tt might have a different name than `make`.
  Possibly `gmake`.
* `prove` - This program is part of any normal Perl installation.
* `curl` - Used to install ys if it is not already installed.

It is extremely likely that you already have all of these programs installed.


<!-- Keep this comment:

  This document should contain instructions on how to run the exercise's tests.

  The instructions should be short and to the point.

  The docs/TESTS.md file can contain a more verbose description on how to run
  tests.

  When a student downloads an exercise via the CLI, this file's contents are
  included into the HELP.md file.

  See https://exercism.org/docs/building/tracks/shared-files for more
  information. -->
