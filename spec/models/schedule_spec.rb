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
        Timecop.freeze
        @s = FactoryBot.create :schedule
        @s.answer_card 1
      end
      after(:each) do
        Timecop.return
      end

      it "places it in learning queue" do
        expect(@s.queue).to eq "learn"
      end
      it "sets due to 1 minutes from now" do
        expect(@s.due).to eq (Time.now + 1.minutes).to_i
      end
      it "sets learning step to 1 (from config)" do
        conf = @s.konfig
        expect(conf[:starting_step]).to eq 1
        expect(@s.learning_step).to eq conf[:starting_step]
      end
      it "sets reps to 1" do
        expect(@s.reps).to eq 1
      end
      it "interval is 0" do
        expect(@s.interval).to eq 0
      end
      it "lapsed is false" do
        expect(@s.lapsed).to eq false
      end
      it "ef is 2.5" do
        expect(@s.ef).to eq 2.5
      end
    end

    context "with 2" do
      before(:each) do
        Timecop.freeze
        @s = FactoryBot.create :schedule
        @s.answer_card 2
      end
      after(:each) do
        Timecop.return
      end

      it "places it in learning queue" do
        expect(@s.queue).to eq "learn"
      end
      it "sets due to 10 minutes from now" do
        expect(@s.due).to eq (Time.now + 10.minutes).to_i
      end
      it "sets learning step to 2 (from config)" do
        conf = @s.konfig
        expect(conf[:starting_step]).to eq 1
        expect(@s.learning_step).to eq 2
      end
      it "sets reps to 1" do
        expect(@s.reps).to eq 1
      end
      it "interval is 0" do
        expect(@s.interval).to eq 0
      end
      it "lapsed is false" do
        expect(@s.lapsed).to eq false
      end
      it "ef is 2.5" do
        expect(@s.ef).to eq 2.5
      end
    end

    context "with 3" do
      before(:each) do
        Timecop.freeze
        @s = FactoryBot.create :schedule
        @s.answer_card 3
      end
      after(:each) do
        Timecop.return
      end

      it "places it in rev queue" do
        expect(@s.queue).to eq "review"
      end
      it "sets due to 1 day from now" do
        expect(@s.due).to eq (Time.now + 4.day).to_i
      end
      it "sets learning step to nil" do
        conf = @s.konfig
        expect(conf[:starting_step]).to eq 1
        expect(@s.learning_step).to be nil
      end
      it "sets reps to 1" do
        expect(@s.reps).to eq 1
      end
      it "sets interval to 4" do
        expect(@s.interval).to eq 4
      end
      it "lapsed is false" do
        expect(@s.lapsed).to eq false
      end
      it "ef is 2.5" do
        expect(@s.ef).to eq 2.5
      end
    end
  end


  context "Answering a learn card" do
    context "with 1" do
      before(:each) do
        Timecop.freeze
        @s = FactoryBot.create :schedule, queue: :learn, reps: 4, due: (Time.now+3.minutes).to_i, learning_step: 2
        @s.answer_card 1
      end
      after(:each) do
        Timecop.return
      end

      it "places it in learning queue" do
        expect(@s.queue).to eq "learn"
      end
      it "sets due to 1 minutes from now" do
        expect(@s.due).to eq (Time.now + 1.minutes).to_i
      end
      it "sets learning step to 1 (from config)" do
        conf = @s.konfig
        expect(conf[:starting_step]).to eq 1
        expect(@s.learning_step).to eq conf[:starting_step]
      end
      it "increase reps" do
        expect(@s.reps).to eq 5
      end
      it "interval is 0" do
        expect(@s.interval).to eq 0
      end
      it "lapsed is false" do
        expect(@s.lapsed).to eq false
      end
      it "ef is 2.5" do
        expect(@s.ef).to eq 2.5
      end
    end

    context "with 2, on step 1" do
      before(:each) do
        Timecop.freeze
        @s = FactoryBot.create :schedule, queue: :learn, reps: 4, due: (Time.now+3.minutes).to_i, learning_step: 1
        @s.answer_card 2
      end
      after(:each) do
        Timecop.return
      end

      it "places it in learning queue" do
        expect(@s.queue).to eq "learn"
      end
      it "sets due to 10 minutes from now (from config)" do
        conf = @s.konfig
        expect((conf[:grad_steps].split)[1]).to eq "10"
        expect(@s.due).to eq (Time.now + 10.minutes).to_i
      end
      it "increases learning step" do
        expect(@s.learning_step).to eq 2
      end
      it "increase reps" do
        expect(@s.reps).to eq 5
      end
      it "interval is 0" do
        expect(@s.interval).to eq 0
      end
      it "lapsed is false" do
        expect(@s.lapsed).to eq false
      end
      it "ef is 2.5" do
        expect(@s.ef).to eq 2.5
      end
    end

    context "with 2, on final step" do
      before(:each) do
        Timecop.freeze
        @s = FactoryBot.create :schedule, queue: :learn, reps: 4, due: (Time.now+3.minutes).to_i, learning_step: 2
        @s.answer_card 2
      end
      after(:each) do
        Timecop.return
      end

      it "places it in review queue" do
        expect(@s.queue).to eq "review"
      end
      it "sets due to 1 day from now" do
        expect(@s.due).to eq (Time.now + 1.day).to_i
      end
      it "sets learning step to nil" do
        expect(@s.learning_step).to eq nil
      end
      it "increase reps" do
        expect(@s.reps).to eq 5
      end
      it "interval is 1" do
        expect(@s.interval).to eq 1
      end
      it "lapsed is false" do
        expect(@s.lapsed).to eq false
      end
      it "ef is 2.5" do
        expect(@s.ef).to eq 2.5
      end
    end

    context "with 3" do
      before(:each) do
        Timecop.freeze
        @s = FactoryBot.create :schedule, queue: :learn, reps: 4, due: (Time.now+3.minutes).to_i, learning_step: 2
        @s.answer_card 3
      end
      after(:each) do
        Timecop.return
      end

      it "places it in review queue" do
        expect(@s.queue).to eq "review"
      end
      it "sets due to 4 days from now" do
        expect(@s.due).to eq (Time.now + 4.day).to_i
      end
      it "sets learning step to nil" do
        expect(@s.learning_step).to eq nil
      end
      it "increase reps" do
        expect(@s.reps).to eq 5
      end
      it "interval is 4" do
        expect(@s.interval).to eq 4
      end
      it "lapsed is false" do
        expect(@s.lapsed).to eq false
      end
      it "ef is 2.5" do
        expect(@s.ef).to eq 2.5
      end
    end

  end
end
