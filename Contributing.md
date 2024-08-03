Contributing
============

The YAMLScript track needs your help!

Right now we are trying to set up lots of YAMLScript exercises.

Here is our [To Do List for Exercises](ToDo.md).

There is tooling to help you out:

* `make generate-all slug=<exercise-slug-name>`

  This will generate almost everything for a new exerise.
  The new files will be under `exercises/practice/<exercise-slug-name>`.

* `make reset`

  Undoes the work of a `make generate-all` if you want to start over.

* `make test`

  Run tests of all the exercises.

* `make check`

  Run other checks to make sure everything is ok before committing your work.

* Look in Makefile for other helpers.


## Making a New Exercise

First pick an exercise from the To Do list.

Generate the exercise with `make generate-all slug=<slug>`.

Run `cd exercises/practice/<slug>/.meta`.

Open up the `<slug>.ys` and `<slug>-test.ys` files in your editor.

The `<slug>.ys` file is your solution to the exercise and it needs to pass the
tests.
The `<slug>.ys` file will have commented out Clojure code in it if the exercise
you chose had a Clojure implementation.
You can use this code as inspiration for your solution.

To run the tests, run `make test`.

Each test will have a `SKIP: true` line. You'll need to remove that line to
make a test active.

Iterate until you pass all the tests.

Add your GitHub id to the `config.json` file in the `authors` section.

Now go back to the root directory.

Edit the `config.yaml` file and change the `difficulty` number for your new
exercise.
You can use the exercise's difficulty number from the ToDo file.

You should also move your new config section in the YAML file to the alphabetic
order position.

Run `make check` from the root directory.

If it passes, commit your code and submit a Pull Request!


## Getting Help

You can find me (Ingy) or other YAMLScript people online to ask questions here:

* [Ingy on Matrix](https://matrix.to/#/@ingy:yaml.io)
* [YAMLScript on Matrix](https://matrix.to/#/#chat-yamlscript:yaml.io)
* [Ingy on Slack](https://clojurians.slack.com/team/U05H8N9V0HZ)
* [YAMLScript on Slack](https://clojurians.slack.com/archives/C05HQFMTURF)
* [YAMLScript on IRC](https://web.libera.chat/gamja/#yamlscript)
