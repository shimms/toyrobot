class ToyRobot::ActionResult
    attr_accessor :success, :message

    def initialize(success:, message: nil)
        @success, @message = success, message
    end
end