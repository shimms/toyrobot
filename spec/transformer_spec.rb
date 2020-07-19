require 'spec_helper'

RSpec.describe ToyRobot::Transformer do
    describe "converting action type to lowercase strings" do
        it "returns the expected string" do
            expect(subject.apply({action: "FOO"})).to eq({action: "foo"})
        end
    end

    describe "converting place arguments" do
        let(:input) { {
            action: "PLACE",
            x: "1",
            y: "2",
            direction: "NORTH"
        }}

        it "converts action type to lowercase string" do
            expect(subject.apply(input)).to include({
                action: "place"
            })
        end

        it "converts x to integer" do
            expect(subject.apply(input)).to include({
                x: 1
            })
        end

        it "converts y to integer" do
            expect(subject.apply(input)).to include({
                y: 2
            })
        end

        it "converts direction to lowercase string" do
            expect(subject.apply(input)).to include({
                direction: "north"
            })
        end        
    end
end
