require 'spec_helper'

RSpec.shared_examples "requires placement" do
    let(:action) { described_class.new }

    describe "validate!" do
        let(:robot) { double(ToyRobot::Robot) }

        before :each do 
            allow(robot).to receive(:name) { "Data" }
        end

        context "when the robot has not been placed" do
            before :each do
                allow(robot).to receive(:placed?) { false }
            end
            
            it "raises the correct error" do
                expect { action.validate!(robot) }.to raise_error(ToyRobot::InvalidActionError, "Must place Data before issuing other commands")
            end
        end
    end
end

RSpec.shared_examples "requires only placement" do
    describe "validate!" do
        let(:robot) { double(ToyRobot::Robot) }

        before :each do 
            allow(robot).to receive(:name) { "Data" }
        end

        context "when the robot has been placed" do
            before :each do
                allow(robot).to receive(:placed?) { true }
            end

            it "returns nil" do
                expect(subject.validate!(robot)).to be_nil
            end
        end
    end
end

RSpec.shared_examples "exists" do
    describe "exists?" do
        it "returns false" do
            expect(subject.exists?).to eq(true)
        end
    end
end

RSpec.shared_examples "no query" do
    describe "query?" do
        it "returns nil" do
            expect(subject.query(double(ToyRobot::Robot))).to be_nil
        end
    end
end
