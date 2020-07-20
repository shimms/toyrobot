class ToyRobot::Reducer
    attr_accessor :history

    def initialize
        @history = []
    end

    def perform(state: {}, action:)
        old_state = state.dup
        no_change = false

        case action.type
        when "place"
            state = place(state, action)
        when "right"
            state = right(state, action)
        when "left"
            state = left(state, action)
        when "move"
            state = move(state, action)
        else
            no_change = true
        end

        self.history.push(old_state) unless no_change

        state
    end

    private
    
    def place(state, action)
        payload = action.payload
        
        state[:placed] = true
        state[:x] = payload[:x]
        state[:y] = payload[:y]
        state[:direction] = payload[:direction]

        state
    end

    def right(state, action)
        turn(state, action, 1)
    end

    def left(state, action)
        turn(state, action, -1)
    end

    def move(state, action)
        mutator = action.heading_mutators[state[:direction]]

        state[:x] = state[:x] + mutator[:dx]
        state[:y] = state[:y] + mutator[:dy]

        state
    end

    def turn(state, action, direction)
        slot = ToyRobot::Robot::Bearings::ALL.find_index(state[:direction])
        state[:direction] = ToyRobot::Robot::Bearings::ALL.rotate(direction)[slot]

        state
    end
end
