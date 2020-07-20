module ToyRobot::Actions
end

class ToyRobot::Action
    attr_accessor :payload

    def initialize(payload = {})
        @payload = payload    
    end

    def type
        self.class.name.gsub(/ToyRobot\:\:Actions\:\:(.+)Action/) { $1.downcase }
    end
    
    def exists?
        true
    end

    def query(robot)
        # noop
    end

    def validate!(robot)
        raise ToyRobot::InvalidActionError.new("Must place #{robot.name} before issuing other commands") unless robot.placed?
    end
end