require 'spec_helper'

RSpec.describe ToyRobot::Actions::PlaceAction do
    it_behaves_like "exists"
    it_behaves_like "no query"

    describe "type" do
        it "returns 'place'" do
            expect(subject.type).to eq('place')
        end
    end

    describe "validate!" do
        let(:inside_placement) { { x: 2, y: 1, direction: "north" } }
        let(:outside_placement) { { x: 10, y: 6, direction: "north" } }
        let(:robot) { double(ToyRobot::Robot) }
        
        before :each do
            allow(robot).to receive(:can_be_placed_at?).with(2, 1) { true }
            allow(robot).to receive(:can_be_placed_at?).with(10, 6) { false }
        end
        
        context "when the coordinates are within the bounds of the world" do
            subject { ToyRobot::Actions::PlaceAction.new(inside_placement) }

            it "returns true" do
                expect(subject.validate!(robot)).to be_nil
            end
        end

        context "when the coordinates are outside the bounds of the world" do         
            subject { ToyRobot::Actions::PlaceAction.new(outside_placement) }

            it "raises the correct error" do
                expect { subject.validate!(robot) }.to raise_error(ToyRobot::InvalidActionError, "I'm sorry Dave, I'm afraid I can't do that.")
            end
        end
    end
end