module ToyRobot
end

require './lib/toy_robot/parser.rb'
require './lib/toy_robot/transformer.rb'
require './lib/toy_robot/world.rb'
require './lib/toy_robot/robot.rb'
require './lib/toy_robot/cli.rb'
require './lib/toy_robot/reducer.rb'
require './lib/toy_robot/invalid_action_error.rb'
require './lib/toy_robot/action.rb'
require './lib/toy_robot/action_creator.rb'
require './lib/toy_robot/action_result.rb'

# Include all actions
Dir[File.join(__dir__, 'toy_robot', 'actions', '*.rb')].each { |file| require file }
