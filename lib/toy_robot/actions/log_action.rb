class ToyRobot::Actions::LogAction < ToyRobot::Action
    def query(robot)
        robot.logs
    end
end