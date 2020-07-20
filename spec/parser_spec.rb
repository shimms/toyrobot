require 'spec_helper'

RSpec.describe ToyRobot::Parser do   
    describe "parsing simple actions" do
        context "when a valid command is provided" do
            describe "MOVE" do
                it "returns the correct action" do
                    expect(subject.parse("MOVE")).to eq({action: "MOVE"})
                end
            end    

            describe "LEFT" do
                it "returns the correct action" do
                    expect(subject.parse("LEFT")).to eq({action: "LEFT"})
                end
            end     

            describe "RIGHT" do
                it "returns the correct action" do
                    expect(subject.parse("RIGHT")).to eq({action: "RIGHT"})
                end
            end     

            describe "REPORT" do
                it "returns the correct action" do
                    expect(subject.parse("REPORT")).to eq({action: "REPORT"})
                end
            end             
        end 

        context "when an ivalid command is provided" do
            it "throws an error" do
                expect { subject.parse("FOOBAR") }.to raise_error(Parslet::ParseFailed)
            end
        end
    end

    describe "parsing command with argumnets" do
        context "when valid arguments are provided" do
            it "returns the correct action and arguments" do
                expect(subject.parse("PLACE 1,2,NORTH")).to match({action: "PLACE", x: "1", y: "2", direction: "NORTH"})
            end
        end

        context "when invalid arguments are provided" do
            it "throws an error" do
                expect { subject.parse("PLACE 1,2,DOWN") }.to raise_error(Parslet::ParseFailed)
            end
        end        
    end
end
