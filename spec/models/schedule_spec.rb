require 'rails_helper'

RSpec.describe Schedule, type: :model do

  context "Creating a new Schedule" do

    it "correctly sets default values" do
      s = FactoryBot.build :schedule
      expect(s.due).to be_nil
      expect(s.learning_step).to be_nil
      expect(s.queue).to eq "unseen"
      expect(s.lapsed).to be false
      expect(s.ef).to eq 2.5
      expect(s.reps).to eq 0
      expect(s.interval).to eq 0
      expect(s.card).to be_valid
      expect(s.student).to be_valid

    end

  end

  context "Answering an unseen card" do
    context "with 1" do
      before(:each) do
        @s = FactoryBot.create :schedule
        @s.answer_card 1
      end
      it "places it in learning queue" do
        expect(@s.queue).to eq "learn"
      end

    end
  end
end
