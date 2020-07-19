require 'securerandom'
require 'forwardable'

class ToyRobot::Robot
    extend Forwardable

    INITIAL_STATE = { placed: false }
    NAMES = ['Gerty', 'Data', 'Lore', 'Robo', 'Giddi', 'B-4', 'Tet', 'Ava']
    
    module Bearings
        NORTH = "north"
        EAST = "east"
        SOUTH = "south"
        WEST = "west"

        ALL = [
            ToyRobot::Robot::Bearings::NORTH, 
            ToyRobot::Robot::Bearings::EAST,
            ToyRobot::Robot::Bearings::SOUTH,
            ToyRobot::Robot::Bearings::WEST,
        ]
    end

    HEADING_MUTATORS = {
        ToyRobot::Robot::Bearings::NORTH => {dx: 0, dy: 1},
        ToyRobot::Robot::Bearings::EAST => {dx: 1, dy: 0},
        ToyRobot::Robot::Bearings::SOUTH => {dx: 0, dy: -1},
        ToyRobot::Robot::Bearings::WEST => {dx: -1, dy: 0},
    }

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

        case action[:type]
        when "place"
            return validate_place(action[:payload])
        when "move"
            return validate_move
        else
            [true, nil]
        end
    end

    private

    def validate_place(payload)
        return [false, "I'm sorry Dave, I'm afraid I can't do that."] unless @world.within_bounds?(payload[:x], payload[:y])

        [true, nil]
    end

    def validate_move
        mutator = ToyRobot::Robot::HEADING_MUTATORS[@state[:direction]]
        
        return [false, "I'm sorry Dave, I'm afraid I can't do that."] unless @world.within_bounds?(@state[:x] + mutator[:dx], @state[:y] + mutator[:dy])

        [true, nil]
    end
end