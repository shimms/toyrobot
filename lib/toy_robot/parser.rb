require 'parslet' 

class ToyRobot::Parser < Parslet::Parser
    # Structure things
    rule(:comma)      { str(',') }
    rule(:space)        { str( ' ') }
    rule(:integer)    { match('[0-9]').repeat(1) }
    rule(:direction) { (stri("NORTH") | stri("EAST") | stri("SOUTH") | stri("WEST")).as(:direction) }

    # Simple verbs
    rule(:action) { (stri("MOVE") | stri("LEFT") | stri("RIGHT") | stri("REPORT")).as(:action) }
    
    # Semi-complex grammars
    rule(:place) { stri("PLACE").as(:action) >> space >> integer.as(:x) >> comma >> integer.as(:y) >> comma >> direction}
    
    # Put it all together
    rule(:valid_command) { place | action }
    root(:valid_command)

    def transform_input(input)
        begin
            command = ToyRobot::Transformer.new.apply(parse(input))
            action = command.delete(:action)

            { type: action.to_s.downcase, payload: command || {} }
        rescue Parslet::ParseFailed => e
            nil
        end
    end
        
    def stri(str)
        key_chars = str.split(//)
        key_chars.
        collect! { |char| match["#{char.upcase}#{char.downcase}"] }.
        reduce(:>>)
    end
end
