class ToyRobot::Action
    def name
        raise "Must be implemented"
    end

    def valid?
        true
    end

    def help
        "Usage: #{name}"
    end
end