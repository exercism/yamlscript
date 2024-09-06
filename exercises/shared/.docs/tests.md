# Tests

To test your solution simply run:

```bash
make test
```

This will run the test file `<exercise-name>-test.ys` which contains all of the
tests that you will need to make pass for the solution to be correct.
You should study the test file to understand exactly what your solution needs
to do.

> Note: The first time you run `make test` it will also make sure that the
> correct version of the `ys` YAMLScript interpreter is installed in the
> correct place.

If you run `make test` before changing any files, all the tests will fail.
The normal exercise development process is to iteratively improve your
solution, running `make test` after each change, until all the tests pass.


## Testing Prerequisites

YAMLScript currently runs on MacOS and Linux.

Your computer will need to have the following very common commands installed:

* `bash` - You can run the tests under any shell, but `bash` must be available.
* `make` - You must use GNU `make` to run the tests. It might have a different
  name than `make`. Possibly `gmake`.
* `prove` - This program is part of any normal Perl installation.
* `curl` - Used to install ys if it is not already installed.

It is extremely likely that you already have all of these programs installed.
