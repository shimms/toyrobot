require 'spec_helper'
require 'tty-command'

RSpec.describe "toyrobot" do
    it "runs without error" do
        cmd = TTY::Command.new
        actual = cmd.run('./bin/toyrobot < STEPS').out.chomp

        expect(actual).to eq('4,3,SOUTH')
    end
end