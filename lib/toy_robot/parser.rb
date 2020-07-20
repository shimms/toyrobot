require 'parslet' 

class ToyRobot::Parser < Parslet::Parser
    SIMPLE_VERBS = %w(MOVE LEFT RIGHT REPORT LOGS)
    COMPLEX_VERBS = %w(PLACE)

    def valid_commands
        SIMPLE_VERBS + COMPLEX_VERBS
    end

    # Simple verbs
    SIMPLE_VERBS.each do |verb|
        rule(verb.downcase.to_sym) { stri(verb).as(:action) }
    end

    # Semi-complex grammars
    rule(:comma)      { str(',') }
    rule(:space)        { str( ' ') }
    rule(:integer)    { match('[0-9]').repeat(1) }
    rule(:direction) { (stri("NORTH") | stri("EAST") | stri("SOUTH") | stri("WEST")).as(:direction) }
    rule(:place) { stri("PLACE").as(:action) >> space >> integer.as(:x) >> comma >> integer.as(:y) >> comma >> direction}
    
    # Put it all together
    rule(:valid_command) { place | move | left | right | report | logs }
    root(:valid_command)

    def transform_input(input)
        begin
            ToyRobot::Transformer.new.apply(parse(input))
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
