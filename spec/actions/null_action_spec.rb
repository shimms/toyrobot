require 'spec_helper'

RSpec.describe ToyRobot::Actions::NullAction do
    describe "type" do
        it "returns 'null'" do
            expect(subject.type).to eq('null')
        end
    end 

    describe "exists?" do
        it "returns false" do
            expect(subject.exists?).to eq(false)
        end
    end
end
