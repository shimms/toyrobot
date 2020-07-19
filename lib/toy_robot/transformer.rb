require 'parslet' 

class ToyRobot::Transformer < Parslet::Transform
    rule(:action => simple(:action)) { { action: action.to_s.downcase } }

    rule(:action => simple(:action), :x => simple(:x), :y => simple(:y), :direction => simple(:direction) ) { {
        action: action.to_s.downcase,
        x: x.to_i,
        y: y.to_i,
        direction: direction.to_s.downcase
    } }
end