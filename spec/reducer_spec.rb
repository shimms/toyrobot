require 'spec_helper'

RSpec.describe ToyRobot::Reducer do
    describe "place" do
        let(:action) { ToyRobot::Actions::PlaceAction.new({x: 1, y: 0, direction: "east"})}

        it "sets the correct placement" do
            expect(subject.perform(action: action)).to match({
                placed: true,
                x: 1,
                y: 0,
                direction: "east"
            })
        end
    end

    describe "right" do
        let(:action) { ToyRobot::Actions::RightAction.new }

        context "when the current heading is north" do
            it "sets the heading to east" do
                expect(subject.perform(state: {direction: "north"}, action: action)).to match({
                    direction: "east"
                })
            end
        end

        context "when the current heading is east" do
            it "sets the heading to south" do
                expect(subject.perform(state: {direction: "east"}, action: action)).to match({
                    direction: "south"
                })
            end
        end

        context "when the current heading is south" do
            it "sets the heading to west" do
                expect(subject.perform(state: {direction: "south"}, action: action)).to match({
                    direction: "west"
                })
            end
        end

        context "when the current heading is west" do
            it "sets the heading to north" do
                expect(subject.perform(state: {direction: "west"}, action: action)).to match({
                    direction: "north"
                })
            end
        end
    end

    describe "left" do
        let(:action) { ToyRobot::Actions::LeftAction.new }

        context "when the current heading is north" do
            it "sets the heading to west" do
                expect(subject.perform(state: {direction: "north"}, action: action)).to match({
                    direction: "west"
                })
            end
        end

        context "when the current heading is west" do
            it "sets the heading to south" do
                expect(subject.perform(state: {direction: "west"}, action: action)).to match({
                    direction: "south"
                })
            end
        end

        context "when the current heading is south" do
            it "sets the heading to east" do
                expect(subject.perform(state: {direction: "south"}, action: action)).to match({
                    direction: "east"
                })
            end
        end

        context "when the current heading is east" do
            it "sets the heading to north" do
                expect(subject.perform(state: {direction: "east"}, action: action)).to match({
                    direction: "north"
                })
            end
        end
    end

    describe "move" do
        let(:action) { ToyRobot::Actions::MoveAction.new }

        context "when heading is north" do
            it "sets the position correctly" do
                expect(subject.perform(state: {
                    placed: true,
                    x: 2,
                    y: 2,
                    direction: "north"
                }, action: action)).to match({
                    placed: true,
                    x: 2,
                    y: 3,
                    direction: "north"
                })
            end
        end

        context "when heading is east" do
            it "sets the position correctly" do
                expect(subject.perform(state: {
                    placed: true,
                    x: 2,
                    y: 2,
                    direction: "east"
                }, action: action)).to match({
                    placed: true,
                    x: 3,
                    y: 2,
                    direction: "east"
                })
            end
        end

        context "when heading is south" do
            it "sets the position correctly" do
                expect(subject.perform(state: {
                    placed: true,
                    x: 2,
                    y: 2,
                    direction: "south"
                }, action: action)).to match({
                    placed: true,
                    x: 2,
                    y: 1,
                    direction: "south"
                })
            end
        end

        context "when heading is west" do
            it "sets the position correctly" do
                expect(subject.perform(state: {
                    placed: true,
                    x: 2,
                    y: 2,
                    direction: "west"
                }, action: action)).to match({
                    placed: true,
                    x: 1,
                    y: 2,
                    direction: "west"
                })
            end
        end
    end
end
