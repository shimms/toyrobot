require 'spec_helper'

RSpec.describe ToyRobot::Actions::LeftAction do
    it_behaves_like "requires placement"
    it_behaves_like "requires only placement"    
    it_behaves_like "exists"
    it_behaves_like "no query"
    
    describe "type" do
        it "returns 'left'" do
            expect(subject.type).to eq('left')
        end
    end 
end