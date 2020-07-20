require 'spec_helper'

RSpec.describe ToyRobot::Robot do
    let(:world) { double(ToyRobot::World) }
    let(:reducer) { double(ToyRobot::Reducer) }

    subject { described_class.new(world, reducer) }

    before :each do
        allow(world).to receive(:register_robot)
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

    describe "can_be_placed_at?" do
        it "delegates to world" do
            expect(world).to receive(:within_bounds?).with(1,2).once

            subject.can_be_placed_at?(1, 2)
        end
    end
    
    describe "placed?" do
        context "when the robot has been placed" do
            before :each do
                subject.state = {
                    placed: true
                }
            end

            it "returns true" do
                expect(subject.placed?).to eq(true)
            end
        end
        
        context "when the robot has not been placed" do
            before :each do
                subject.state = {
                    placed: false
                }
            end

            it "returns false" do
                expect(subject.placed?).to eq(false)
            end
        end
    end
end
