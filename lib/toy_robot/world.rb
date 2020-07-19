class ToyRobot::World
    attr_accessor :width, :height, :parser, :robots, :reducer

    def initialize(reducer, parser, width, height)
        @reducer = reducer
        @parser = parser
        @width = width
        @height = height
        @robots = {}
    end

    def register_robot(robot)
        @robots[robot.id] = robot
    end

    def within_bounds?(x, y)
      (0..@width).include?(x) && (0..@height).include?(y)
    end
end
