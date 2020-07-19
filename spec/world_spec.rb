require 'spec_helper'

RSpec.describe ToyRobot::World do
    let(:reducer) { double(ToyRobot::Reducer)}
    let(:parser) { double(ToyRobot::Parser)}
    
    subject { ToyRobot::World.new(reducer, parser, 5, 5)}

    describe "register_robot" do
        it "successfully registers the robot" do
            expect(subject.robots).to be_empty

            subject.register_robot(ToyRobot::Robot.new(subject))

            expect(subject.robots.count).to eq(1)
        end
    end

    describe "within_bounds?" do
        context "when both x and y are within the bounds of the world" do
            it "returns true" do
                expect(subject.within_bounds?(4, 2)).to eq(true)
            end
        end

        context "when only x is outside the bounds" do
            it "returns false" do
                expect(subject.within_bounds?(7, 2)).to eq(false)
            end
        end

        context "when only y is outside the bounds" do
            it "returns false" do
                expect(subject.within_bounds?(4, 7)).to eq(false)
            end
        end

        context "when both x and y are outside the bounds" do
            it "returns false" do
                expect(subject.within_bounds?(7, 9)).to eq(false)
            end
        end

        # fix bug using exclusive instead of inclusive range
        context "when x and y are on the edge" do
            it "returns true" do
                expect(subject.within_bounds?(5, 5)).to eq(true)
            end
        end
    end
end
