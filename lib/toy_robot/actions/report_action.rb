class ToyRobot::Actions::ReportAction < ToyRobot::Action
    def query(robot)
        x, y = robot.position

        "#{x},#{y},#{robot.direction.upcase}"
    end
end