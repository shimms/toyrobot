class ToyRobot::Actions::MoveAction < ToyRobot::Action
    def heading_mutators
        {
            ToyRobot::Robot::Bearings::NORTH => {dx: 0, dy: 1},
            ToyRobot::Robot::Bearings::EAST => {dx: 1, dy: 0},
            ToyRobot::Robot::Bearings::SOUTH => {dx: 0, dy: -1},
            ToyRobot::Robot::Bearings::WEST => {dx: -1, dy: 0},
        }
    end

    def validate!(robot)
        super

        mutator = heading_mutators[robot.direction]
        x, y = robot.position

        unless robot.can_be_placed_at?(x + mutator[:dx], y + mutator[:dy])
            raise ToyRobot::InvalidActionError.new("I'm sorry Dave, I'm afraid I can't do that.")
        end 
    end
end