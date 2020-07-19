class ToyRobot::Reducer
    attr_accessor :history

    def initialize
        @history = []
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
        turn(state, payload, 1)
    end

    def left(state, payload)
        turn(state, payload, -1)
    end

    def move(state, payload)
        mutator = ToyRobot::Robot::HEADING_MUTATORS[state[:direction]]

        state[:x] = state[:x] + mutator[:dx]
        state[:y] = state[:y] + mutator[:dy]

        state
    end

    def turn(state, payload, direction)
        slot = ToyRobot::Robot::Bearings::ALL.find_index(state[:direction])
        state[:direction] = ToyRobot::Robot::Bearings::ALL.rotate(direction)[slot]

        state
    end
end
