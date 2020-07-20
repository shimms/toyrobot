require 'spec_helper'

RSpec.describe ToyRobot::Actions::MoveAction do
    it_behaves_like "requires placement"
    it_behaves_like "exists"
    it_behaves_like "no query"

    describe "type" do
        it "returns 'move'" do
            expect(subject.type).to eq('move')
        end
    end 

    describe "heading mutators" do
        describe "north mutator" do
            it "has the correct deltas" do
                expect(subject.heading_mutators[ToyRobot::Robot::Bearings::NORTH]).to match({dx: 0, dy: 1})
            end
        end

        describe "east mutator" do
            it "has the correct deltas" do
                expect(subject.heading_mutators[ToyRobot::Robot::Bearings::EAST]).to match({dx: 1, dy: 0})
            end
        end

        describe "south mutator" do
            it "has the correct deltas" do
                expect(subject.heading_mutators[ToyRobot::Robot::Bearings::SOUTH]).to match({dx: 0, dy: -1})
            end
        end

        describe "west mutator" do
            it "has the correct deltas" do
                expect(subject.heading_mutators[ToyRobot::Robot::Bearings::WEST]).to match({dx: -1, dy: 0})
            end
        end
    end

    describe "validate!" do
        let(:robot) { double(ToyRobot::Robot) }

        before :each do
            allow(robot).to receive(:placed?) { true }
            allow(robot).to receive(:position) { [2,4] }
            allow(robot).to receive(:direction) { "north" }
        end

        context "when the requested movement would place the robot outside the bounds of the world" do
            before :each do
                allow(robot).to receive(:can_be_placed_at?).with(2, 5) { false }
            end

            it "raises the correct error" do
                expect { subject.validate!(robot) }.to raise_error(ToyRobot::InvalidActionError, "I'm sorry Dave, I'm afraid I can't do that.")
            end
        end

        context "when the requested movement would place the robot inside the bounds of the world" do
            before :each do        
                allow(robot).to receive(:can_be_placed_at?).with(2, 5) { true }
            end

            it "returns true" do
                expect(subject.validate!(robot)).to be_nil
            end
        end
    end
end
