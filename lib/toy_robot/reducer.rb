class ToyRobot::Reducer
    attr_accessor :history

    module Directions
        RIGHT = 1
        LEFT = -1
    end

    module Bearings
        NORTH = "north"
        EAST = "east"
        SOUTH = "south"
        WEST = "west"

        ALL = [
            ToyRobot::Reducer::Bearings::NORTH, 
            ToyRobot::Reducer::Bearings::EAST,
            ToyRobot::Reducer::Bearings::SOUTH,
            ToyRobot::Reducer::Bearings::WEST,
        ]
    end

    def initialize
        @history = []

        @heading_mutators = {
            ToyRobot::Reducer::Bearings::NORTH => {dx: 0, dy: 1},
            ToyRobot::Reducer::Bearings::EAST => {dx: 1, dy: 0},
            ToyRobot::Reducer::Bearings::SOUTH => {dx: 0, dy: -1},
            ToyRobot::Reducer::Bearings::WEST => {dx: -1, dy: 0},
        }
    end

    def perform(state: {}, action:)
        self.history.push state.dup

        case action[:type]
        when "place"
            state = place(state, action[:payload])
        when "right"
            state = right(state, action[:payload])
        when "left"
            state = left(state, action[:payload])
        when "move"
            state = move(state, action[:payload])
        end

        state
    end

    private
    
    def place(state, payload)
        state[:placed] = true
        state[:x] = payload[:x]
        state[:y] = payload[:y]
        state[:direction] = payload[:direction]

        state
    end

    def right(state, payload)
        turn(state, payload, ToyRobot::Reducer::Directions::RIGHT)
    end

    def left(state, payload)
        turn(state, payload, ToyRobot::Reducer::Directions::LEFT)
    end

    def move(state, payload)
        mutator = @heading_mutators[state[:direction]]

        state[:x] = state[:x] + mutator[:dx]
        state[:y] = state[:y] + mutator[:dy]

        state
    end

    def turn(state, payload, direction)
        slot = ToyRobot::Reducer::Bearings::ALL.find_index(state[:direction])
        state[:direction] = ToyRobot::Reducer::Bearings::ALL.rotate(direction)[slot]

        state
    end
end