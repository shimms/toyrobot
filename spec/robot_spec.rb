require 'spec_helper'

RSpec.describe ToyRobot::Robot do
    let(:world) { double(ToyRobot::World) }
    let(:parser) { double(ToyRobot::Parser) }

    subject { described_class.new(world) }

    before :each do
        allow(parser).to receive(:transform_input)
        allow(world).to receive(:register_robot)
        allow(world).to receive(:parser) { parser }

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
end
