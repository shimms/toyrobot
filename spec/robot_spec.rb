require 'spec_helper'

RSpec.describe ToyRobot::Robot do
    let(:world) { double(ToyRobot::World) }
    let(:parser) { double(ToyRobot::Parser) }

    subject { described_class.new(world) }

    before :each do
        allow(parser).to receive(:transform_input)
        allow(world).to receive(:register_robot)
        allow(world).to receive(:parser) { parser }
        allow(world).to receive(:height) { 5 }
        allow(world).to receive(:width) { 5 }

        subject.state = {
            placed: true,
            x: 1,
            y: 4,
            direction: "west"
        }
    end

    describe "position" do
        it "returns the correct position" do
            expect(subject.position).to eq([1, 4])
        end
    end

    describe "direction" do
        it "returns the correct direction" do
            expect(subject.direction).to eq("west")
        end
    end

    describe "report" do
        it "returns the correct report" do
            expect(subject.report).to eq("1,4,WEST")
        end
    end

    describe "create_action_response" do
        it "returns the correctly formatted response" do
            expect(subject.create_action_response("foo")).to eq({ message: "foo" })
        end
    end

    describe "create_action" do
        it "uses the parser to build the appropriate action" do
            expect(subject.parser).to receive(:transform_input).with("foo")

            subject.create_action("foo")
        end
    end

    describe "action_valid?" do
        context "when the robot has not been placed" do
            let(:inside_placement) { {type: "place", payload: {x: 2, y: 1, direction: "north"}} }
            let(:outside_placement) { {type: "place", payload: {x: 10, y: 6, direction: "north"}} }
            
            before :each do
                subject.state = {
                    placed: false,
                }

                allow(world).to receive(:within_bounds?).with(2, 1) { true }
                allow(world).to receive(:within_bounds?).with(10, 6) { false }
            end

            describe "report" do
                it "returns false" do
                    expect(subject.action_valid?({type: "report"})[0]).to eq(false)
                end
            end

            describe "right" do
                it "returns false" do
                    expect(subject.action_valid?({type: "right"})[0]).to eq(false)
                end
            end

            describe "left" do
                it "returns false" do
                    expect(subject.action_valid?({type: "left"})[0]).to eq(false)
                end
            end


            context "when the command is PLACE" do
                context "when the coordinates are within the bounds of the world" do
                    it "returns true" do
                        expect(subject.action_valid?(inside_placement)[0]).to eq(true)
                    end
                end

                context "when the coordinates are outside the bounds of the world" do
                    it "returns false" do
                        expect(subject.action_valid?(outside_placement)[0]).to eq(false)
                    end

                    it "returns the correct message" do
                        expect(subject.action_valid?(outside_placement)[1]).to eq("I'm sorry Dave, I'm afraid I can't do that.")
                    end
                end
            end

            context "when the command is not PLACE" do
                it "returns false" do
                    expect(subject.action_valid?({type: "report"})[0]).to eq(false)
                end

                it "returns the correct message" do
                    expect(subject.action_valid?({type: "report"})[1]).to eq("Must place #{subject.name} before issuing other commands")
                end
            end
        end

        context "when the robot has been placed" do
            before :each do
                subject.state = {
                    placed: true,
                    x: 2, 
                    y: 4,
                    direction: "north"
                }
            end

            describe "report" do
                it "returns true" do
                    expect(subject.action_valid?({type: "report"})[0]).to eq(true)
                end
            end

            describe "right" do
                it "returns true" do
                    expect(subject.action_valid?({type: "right"})[0]).to eq(true)
                end
            end

            describe "left" do
                it "returns true" do
                    expect(subject.action_valid?({type: "left"})[0]).to eq(true)
                end
            end

            describe "move" do
                context "when the requested movement would place the robot outside the bounds of the world" do
                    before :each do        
                        allow(world).to receive(:within_bounds?).with(2, 5) { false }
                    end

                    it "returns false" do
                        expect(subject.action_valid?({type: "move"})[0]).to eq(false)
                    end

                    it "returns the correct message" do
                        expect(subject.action_valid?({type: "move"})[1]).to eq("I'm sorry Dave, I'm afraid I can't do that.")
                    end
                end

                context "when the requested movement would place the robot inside the bounds of the world" do
                    before :each do        
                        allow(world).to receive(:within_bounds?).with(2, 5) { true }
                    end

                    it "returns true" do
                        expect(subject.action_valid?({type: "move"})[0]).to eq(true)
                    end
                end
            end
        end
    end
end
