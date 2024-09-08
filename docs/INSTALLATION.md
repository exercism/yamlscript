Installation
============

To write programs in YAMLScript you need to install the YAMLScript command line
interpreter.
This is a binary executable file called `ys`.
It currently works on:

* Linux / Intel
* Linux / ARM
* MacOS / Intel
* MacOS / ARM

> Note: Windows support is planned, but not yet available.

Releases are [available on GitHub](
http://github.com/yaml/yamlscript/releases).


## Automatic Installation

To solve the Exercism YAMLScript exercises you repeatedly modify your solution
program and run `make test` until all the tests pass.

That's it!

The first time you run `make test` it will try to install the specific version
of the `ys` interpreter that is required for the exercise in the
`/path/to/exercism/yamlscript/.local/` directory.

If you've already installed that version of `ys` somewhere in your `PATH`, then
it will silently copy the `ys` interpreter to the correct place.

If not it will prompt you to do a binary release installation, which generally
only takes a few seconds.

If that fails (rare, but it happens sometimes) it will prompt you to do an
automated build from source, which can take a few minutes (but is very reliable
and requires no interaction).

You will only encounter this the first time you run `make test`.
All exercises that are set to use the same version of `ys` will use the same
installation.

> Note: You can also use the `make install-ys` command separately from `make
> test`.
> It will do exactly the same installation process as `make test`, but without
> running the tests afterwards.


For more information about installing YAMLScript, especially for using it
outside of Exercism, see the [YAMLScript Installation Documentation](
https://yamlscript.org/doc/install/).


<!-- Keep this comment:

  This document should describe what the student needs to install
  to allow working on the track on their local system using the CLI.

  You can include the installation instructions in this document, but
  usually it is better to link to a resource with the official installation
  instructions, to prevent the instructions from becoming outdated.

  The contents of this document are displayed on the track's documentation
  page at `https://exercism.org/docs/tracks/yamlscript/installation`.

  See https://exercism.org/docs/building/tracks/docs for more information. -->
