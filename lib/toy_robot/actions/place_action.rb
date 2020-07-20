class ToyRobot::Actions::PlaceAction < ToyRobot::Action
    def validate!(robot)
        unless robot.can_be_placed_at?(payload[:x], payload[:y])
            raise ToyRobot::InvalidActionError.new("I'm sorry Dave, I'm afraid I can't do that.")
        end
    end
end