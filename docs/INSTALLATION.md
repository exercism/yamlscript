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


Here are 3 simple of ways that you can install the `ys` command.


## Binary Installation

For every released version of YAMLScript, the prebuilt binaries for each
supported environment are published [here](
https://github.com/yaml/yamlscript/releases).

The easiest way the install the `ys` command from there is to run this command:

```
$ curl -s https://yamlscript.org/install | BIN=1 bash
Installed $HOME/.local/bin/ys - version 0.1.72
```

You will need to add `$HOME/.local/bin` to you environment's `PATH` variable.

You can test that the installation works by running:

```
$ ys --help

ys - The YAMLScript (YS) Command Line Tool - v0.1.72

Usage: ys [<option...>] [<file>]
...
```

To install `ys` in some other `bin/` directory (which must be in your `PATH`,
you can use the `PREFIX` variable.
To install a version other than the latest you can use the `VERSION` variable.

Something like this:

```
$ curl -s https://yamlscript.org/install | BIN=1 PREFIX=/tmp/ys VERSION=0.1.71 bash
Installed /tmp/ys/bin/ys - version 0.1.71

  *** WARNING: '/tmp/ys/bin' is not in your PATH yet ***
```


## Build From Source

This is extremely easy and the most reliable method, but it takes a couple of
minutes to complete.
Run these commands:

```
$ git clone --branch=0.1.72 http://github.com/yaml/yamlscript
$ make -C yamlscript/ys install # PREFIX=...
```

There are no prerequisites (besides `make`, `curl` and `bash`).

This also installs into `$HOME/.local/bin/ys` by default.


## Using `make install-ys` (in your exercise download)

For each Exercism YAMLScript exercise you download (using the `exercism
download` command), there will be a Makefile.
You will use this repeatedly when you test your YAMLScript solution as you
implement it, by running `make test`.

You can also install `ys` locally in your exercise directory with `make
install-ys`.

You only need to do this once.
This will install `./.ys/bin/ys` for you.
You won't need to add anything to your `PATH` because the Makefile will add it
to the PATH it uses when you run `make test`.

> Note: If you want to use this installation on its own (not via a `make`
> command), then you will need to add its location to your `PATH`.
