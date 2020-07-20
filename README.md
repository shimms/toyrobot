# Robot Challenge

A Ruby solution to the Certsy coding challenge (see [PROBLEM.MD](PROBLEM.md)).

## Running the app

### Docker

Build the docker image:

    > docker build -t toyrobot .

Run the app:

    > docker run -it toyrobot

Run with `--help` to see available options:

    > docker run -it toyrobot ./bin/toyrobot --help
    Usage: toyrobot [options]
     -h, --height height              Height (optional) - defaults to 5
     -w, --width width                Width (optional) - defaults to 5
         --help                       Displays Help

### With RVM

Install RVM, and Ruby 2.7.1, then bundle and run as normal:

    > bundle install
    > ./bin/toyrobot

## Streaming from stdin instead of interactive TTY

You can redirect a file to stdin to run the program without manual intervention:

    > ./bin/toyrobot < STEPS
    4,3,SOUTH

## Running tests

You can run the tests in either Docker or locally.

    docker run -it toyrobot bundle exec rspec

Or

    bundle exec rspec

## Adding new commands

Adding commands is relatively straight foward:

### Update parser

Add the verb required to the parser (`lib/toy_robot/parser.rb`). For simple verbs (that don't require arguments), adding the verb to the `SIMPLE_VERB` array, as well as the bitwise OR'd list of rules will suffice.

For more complicated commands that require additional arguments, or their own grammar, see the example used to define the `PLACE` command. Refer to the [Parslet](http://kschiess.github.io/parslet/) documentation for more details.

### Create action

Add a new class to the `lib/toy_robot/actions` folder following the naming convention `ToyRobot::Actions::{VERB}Action`, inheriting from `ToyRobot::Action`.

For a simple query command, override the `query(robot)` method and return the appropriate output.

For a mutating command, you'll need to add the appropriate section to the state reducer (`lib/toy_robot/reducer.rb`).

If you need to validate the state of the world or robot prior to dispatching your action to the reducer, override the `validate!` method in your action.

Have a look at `ToyRobot::Actions::ReportAction` for an example of a query command, `ToyRobot::Actions::PlaceAction` for an example of a mutating command with custom validation, and `ToyRobot::Actions::MoveAction` for an example of a mutating command without any custom validation.

### Update reducer (if required)

If you're building a mutating action, you'll need to update the state as appropriate in the reducer.

The reducer follows the [State Reducer pattern](https://kentcdodds.com/blog/the-state-reducer-pattern) and is modelled closely on how Redux works with it's implementation of this pattern.

### Implement any required logic

Add any required logic to Robot or World (or elsewhere as needed) to support your command. For example, a `LOGS` command that outputs the history of the robot's journey may need to have a new method defined on `Robot` to be called within the action's `query` method.

### Example

See the `add_log_command` branch for an example of how to add a simple query command.