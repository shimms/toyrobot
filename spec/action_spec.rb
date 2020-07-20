require 'spec_helper'

RSpec.describe ToyRobot::Action do    
    it_behaves_like "requires placement"
    it_behaves_like "requires only placement"
    it_behaves_like "exists"
    it_behaves_like "no query"

    describe "initialization" do
        it "correctly assigns the payload" do
            expect(ToyRobot::Action.new({foo: :bar}).payload).to eq({foo: :bar})
        end
    end
end