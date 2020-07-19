require 'parslet' 

class ToyRobot::Parser < Parslet::Parser
    # Structure things
    rule(:comma)      { str(',') }
    rule(:integer)    { match('[0-9]').repeat(1) }
    rule(:direction) { (str("NORTH") | str("EAST") | str("SOUTH") | str("WEST")).as(:direction) }

    # Simple verbs
    rule(:action) { (str("MOVE") | str("LEFT") | str("RIGHT") | str("REPORT")).as(:action) }
    
    # Semi-complex grammars
    rule(:place) { str("PLACE").as(:action) >> comma >> integer.as(:x) >> comma >> integer.as(:y) >> comma >> direction}
    
    # Put it all together
    rule(:valid_command) { place | action }
    root(:valid_command)
end
