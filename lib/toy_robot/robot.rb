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

    attr_accessor :world, :id, :name, :state
    
    def initialize(world, reducer)
        @world, @reducer = world, reducer

        @id = SecureRandom.uuid
        @name = ToyRobot::Robot::NAMES.sample
        @state = ToyRobot::Robot::INITIAL_STATE

        @world.register_robot(self)
    end

    def execute(action)
        action.validate!(self)

        @state = @reducer.perform(state: @state, action: action)

        return ToyRobot::ActionResult.new(success: true, message: action.query(self))
    rescue ToyRobot::InvalidActionError => e
        return ToyRobot::ActionResult.new(success: false, message: e.message)
    end

    def placed?
        @state[:placed]
    end

    def position
        [@state[:x], @state[:y]]
    end

    def direction
        @state[:direction]
    end

    def can_be_placed_at?(x, y)
        @world.within_bounds?(x, y)
    end
end