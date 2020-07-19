require 'securerandom'
require 'forwardable'

class ToyRobot::Robot
    extend Forwardable

    INITIAL_STATE = { placed: false }
    
    NAMES = ['Gerty', 'Data', 'Lore', 'Robo', 'Giddi', 'B-4', 'Tet', 'Ava']

    attr_accessor :world, :id, :name, :state
    
    delegate [:reducer, :parser] => :@world

    def initialize(world)
        @world = world
        @id = SecureRandom.uuid
        @name = NAMES.sample
        @state = INITIAL_STATE

        @world.register_robot(self)
    end

    def execute(action)
        valid, errors = action_valid?(action)

        return create_action_response(errors) unless valid
        return create_action_response(report) if action[:type] == "report"

        @state = reducer.perform(state: @state, action: action)
    end

    def position
        [@state[:x], @state[:y]]
    end

    def direction
        @state[:direction]
    end

    def report
        x, y = position

        "#{x},#{y},#{direction.upcase}"
    end

    def create_action_response(message)
        { message: message }
    end

    def create_action(input)
        self.parser.transform_input(input)
    end

    def action_valid?(action)
        return [false, "Must place #{@name} before issuing other commands"] if action[:type] != "place" && @state[:placed] == false

        [true, nil]
    end
end