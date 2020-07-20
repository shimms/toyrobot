require 'spec_helper'

RSpec.describe ToyRobot::Actions::ReportAction do
    it_behaves_like "requires placement"
    it_behaves_like "requires only placement"    
    it_behaves_like "exists"
    
    describe "type" do
        it "returns 'report'" do
            expect(subject.type).to eq('report')
        end
    end 

    describe "query" do
        let(:robot) { double(ToyRobot::Robot) }

        before :each do
            allow(robot).to receive(:position) { [1,4] }
            allow(robot).to receive(:direction) { "west" }
        end

        it "returns the correct report" do
            expect(subject.query(robot)).to eq("1,4,WEST")
        end
    end
end
