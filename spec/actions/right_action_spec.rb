require 'spec_helper'

RSpec.describe ToyRobot::Actions::RightAction do
    it_behaves_like "requires placement"
    it_behaves_like "requires only placement"    
    it_behaves_like "exists"
    it_behaves_like "no query"
    
    describe "type" do
        it "returns 'right'" do
            expect(subject.type).to eq('right')
        end
    end 
end