require 'active_support/inflector'

class ToyRobot::ActionCreator
    def self.create(command)
        return ToyRobot::Actions::NullAction.new if command.nil?

        action = command.delete(:action)

        begin
            action_klass = "ToyRobot::Actions::#{action.to_s.classify}Action".constantize
        rescue NameError => e
            return ToyRobot::Actions::NullAction.new 
        end

        action_klass.new(command)
    end
end