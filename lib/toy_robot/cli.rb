require 'optparse'
require 'tty-reader'

class ToyRobot::Cli
    DEFAULT_WIDTH, DEFAULT_HEIGHT = [5,5]

    attr_accessor :robot, :parser

    def initialize(parser, robot, logger)
        @parser, @robot, @logger = parser, robot, logger
    end

    def self.parse_options
        options = {:width => DEFAULT_WIDTH, :height => DEFAULT_HEIGHT}

        option_parser = OptionParser.new do|opts|
            opts.banner = "Usage: toyrobot [options]"

            opts.on('-h', '--height height', 'Height (optional) - defaults to 5') do |height|
                    options[:height] = height;
            end

            opts.on('-w', '--width width', 'Width (optional) - defaults to 5') do |width|
                    options[:width] = width;
            end

            opts.on('--help', '--help', 'Displays Help') do
                puts opts
                puts
                exit
            end
        end

        option_parser.parse!

        options
    end

    def start_interactive
        banner = <<-EOS

        ████████╗ ██████╗ ██╗   ██╗    ██████╗  ██████╗ ██████╗  ██████╗ ████████╗
        ╚══██╔══╝██╔═══██╗╚██╗ ██╔╝    ██╔══██╗██╔═══██╗██╔══██╗██╔═══██╗╚══██╔══╝
           ██║   ██║   ██║ ╚████╔╝     ██████╔╝██║   ██║██████╔╝██║   ██║   ██║   
           ██║   ██║   ██║  ╚██╔╝      ██╔══██╗██║   ██║██╔══██╗██║   ██║   ██║   
           ██║   ╚██████╔╝   ██║       ██║  ██║╚██████╔╝██████╔╝╚██████╔╝   ██║   
           ╚═╝    ╚═════╝    ╚═╝       ╚═╝  ╚═╝ ╚═════╝ ╚═════╝  ╚═════╝    ╚═╝   
                                                                              
        EOS

        puts banner
        reader = TTY::Reader.new

        reader.on(:keyescape) do
            exit_program
        end        
        
        print_welcome
        read_input(reader)
    end

    def start_stream(stream)
        read_stream(stream)

        x, y = @robot.position
        direction = @robot.direction.upcase
        puts "#{x},#{y},#{direction}"
        exit 0
    end

    def read_input(reader)
        loop do
            input = reader.read_line('=> ').chomp

            read(input, ->(message) { puts message } )
        end
    end

    def read_stream(stream)
        while input = stream.gets("\n")&.strip
            read(input, ->(message) { @logger.info(message) }, ->(message) { @logger.error(message) })    
        end
    end

    private

    def read(input, info, error = nil)
        action = ToyRobot::ActionCreator.create(parser.transform_input(input))

        if action.exists?
            result = @robot.execute(action)

            info.call(result.message) if result.message
        else
            (error || info).call "Invalid command, please enter one of: #{@parser.valid_commands.join(', ')}."
        end
    end

    def print_welcome
        puts "🤖 Welcome to Toy Robot."
        puts ""
        puts "#{@robot.name} (your Robot) hasn't landed on the world yet. When you're ready, issue the PLACE command."
        puts ""
        puts "You can exit at any time by hitting the Escape key."
        puts ""
    end

    def exit_program
        puts "💣 Self destruct sequence initiated (don't worry, you'll get new Robot when you start again)..."
        puts ""
        puts "👋"
        puts ""
        exit
    end
end