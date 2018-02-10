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
      it "sets learning step to 0" do
        expect(@s.learning_step).to eq 0
      end
      it "sets learning step to 0, not starting_step" do
        @d = FactoryBot.create :schedule, konfig_args:{grad_steps:'3 5 6 7', starting_step: 2}
        @d.answer_card 1
        expect(@d.learning_step).to eq 0
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
      it "sets learning step to 1 (from config: starting_step)" do
        conf = @s.konfig
        expect(conf[:starting_step]).to eq 1
        expect(@s.learning_step).to eq 1
      end

      it "sets learning step based on config" do
        @d = FactoryBot.create :schedule, konfig_args:{grad_steps:'3 5 6 7', starting_step: 2}
        @d.answer_card 2
        expect(@d.learning_step).to eq 2
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
      it "sets due to 4 days from now" do
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
      it "sets due according to config" do
        @d = FactoryBot.create :schedule, queue: :learn, reps: 6, due: (Time.now-24.minutes).to_i, learning_step: 3, konfig_args:{grad_steps:'3 5 6 7', starting_step: 2}
        @d.answer_card 1

        expect(@s.due).to eq (Time.now + 1.minutes).to_i
        expect(@d.due).to eq (Time.now + 3.minutes).to_i
      end
      it "sets learning step to 0" do
        conf = @s.konfig
        expect(conf[:starting_step]).to eq 1
        expect(@s.learning_step).to eq 0

      end
      it "sets learning step to 0 with different config" do
        @d = FactoryBot.create :schedule, queue: :learn, reps: 6, due: (Time.now-24.minutes).to_i, learning_step: 3, konfig_args:{grad_steps:'3 5 6 7', starting_step: 2}
        @d.answer_card 1
        confd = @d.konfig
        expect(confd[:starting_step]).to eq 2
        expect(@d.learning_step).to eq 0

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

    context "with 2, on step 0" do
      before(:each) do
        Timecop.freeze
        @s = FactoryBot.create :schedule, queue: :learn, reps: 4, due: (Time.now+3.minutes).to_i, learning_step: 0
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
        expect(@s.learning_step).to eq 1
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
        @s = FactoryBot.create :schedule, queue: :learn, reps: 4, due: (Time.now+3.minutes).to_i, learning_step: 1
        @d = FactoryBot.create :schedule, queue: :learn, reps: 6, due: (Time.now-24.minutes).to_i, learning_step: 3, konfig_args:{grad_steps:'3 5 6 7', starting_step: 2}
        @s.answer_card 2
        @d.answer_card 2
      end
      after(:each) do
        Timecop.return
      end

      it "places it in review queue" do
        expect(@s.queue).to eq "review"
        expect(@d.queue).to eq "review"
      end
      it "sets due to 1 day from now" do
        expect(@s.due).to eq (Time.now + 1.day).to_i
        expect(@d.due).to eq (Time.now + 1.day).to_i
      end
      it "sets learning step to nil" do
        expect(@s.learning_step).to eq nil
        expect(@d.learning_step).to eq nil
      end
      it "increase reps" do
        expect(@s.reps).to eq 5
        expect(@d.reps).to eq 7
      end
      it "interval is 1" do
        expect(@s.interval).to eq 1
        expect(@d.interval).to eq 1
      end
      it "lapsed is false" do
        expect(@s.lapsed).to eq false
      end
      it "ef is 2.5" do
        expect(@s.ef).to eq 2.5
      end

      it "shows up as a review card in 4 days" do
        expect(Schedule.due_review.find_by(id:@s.id)).to eq nil
        Timecop.return
        Timecop.freeze(Time.now+1.days)
        expect(Schedule.due_review.find_by(id:@s.id)).to eq @s
      end
    end

    context "with 3" do
      before(:each) do
        Timecop.freeze
        @s = FactoryBot.create :schedule, queue: :learn, reps: 4, due: (Time.now+3.minutes).to_i, learning_step: 1
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

      it "shows up as a review card in 4 days" do
        expect(Schedule.due_review.find_by(id:@s.id)).to eq nil
        Timecop.return
        Timecop.freeze(Time.now+4.days)
        expect(Schedule.due_review.find_by(id:@s.id)).to eq @s
      end
    end
  end

  context "Answering a review card" do
    context "with 1" do
      before(:each) do
        Timecop.freeze
        @s = FactoryBot.create :schedule, queue: :review, reps: 7, due: (Time.now-3.minutes).to_i, ef:2.2, interval:5, konfig_args:{lapse_starting_step: 2, grad_steps:"3 5 7"}
        @s.answer_card 1
      end
      after(:each) do
        Timecop.return
      end
      it "places it in learning queue" do
        expect(@s.queue).to eq "learn"
      end
      it "sets due to 5 min from now" do
        expect(@s.due).to eq (Time.now + 5.minute).to_i
      end
      it "sets learning step to lapse_starting_step" do
        expect(@s.learning_step).to eq 2
      end
      it "increase reps" do
        expect(@s.reps).to eq 8
      end
      it "interval is 1" do
        expect(@s.interval).to eq 1
      end
      it "lapsed is true" do
        expect(@s.lapsed).to eq true
      end
      it "ef is decreased by 0.2" do
        expect(@s.ef).to eq 2.0
      end
    end

    context "with 2" do
      before(:each) do
        Timecop.freeze
        @s = FactoryBot.create :schedule, queue: :review, reps: 7, due: (Time.now-3.minutes).to_i, ef:2.2, interval:5, konfig_args:{lapse_starting_step: 2, grad_steps:"3 5 7"}
        @s.answer_card 2
      end
      after(:each) do
        Timecop.return
      end
      it "places it in review queue" do
        expect(@s.queue).to eq "review"
      end
      it "sets due to 6 days from now" do
        expect(@s.due).to eq (Time.now + 6.days).to_i
      end
      it "learning step still nil" do
        expect(@s.learning_step).to eq nil
      end
      it "increase reps" do
        expect(@s.reps).to eq 8
      end
      it "interval is 5*1.2 = 6" do
        expect(@s.interval).to eq 6
      end
      it "lapsed is false" do
        expect(@s.lapsed).to eq false
      end
      it "ef is decreased by 0.15" do
        expect(@s.ef).to eq 2.05
      end
    end

    context "with 3" do
      before(:each) do
        Timecop.freeze
        @s = FactoryBot.create :schedule, queue: :review, reps: 7, due: (Time.now-3.minutes).to_i, ef:2.2, interval:5, konfig_args:{lapse_starting_step: 2, grad_steps:"3 5 7"}
        @s.answer_card 3
      end
      after(:each) do
        Timecop.return
      end
      it "places it in review queue" do
        expect(@s.queue).to eq "review"
      end
      it "sets due to 11 days from now" do
        expect(@s.due).to eq (Time.now + 11.days).to_i
      end
      it "learning step still nil" do
        expect(@s.learning_step).to eq nil
      end
      it "increase reps" do
        expect(@s.reps).to eq 8
      end
      it "interval is 5*2.2 = 11" do
        expect(@s.interval).to eq 11
      end
      it "lapsed is false" do
        expect(@s.lapsed).to eq false
      end
      it "ef is unchanged" do
        expect(@s.ef).to eq 2.2
      end
    end

    context "with 4" do
      before(:each) do
        Timecop.freeze
        @s = FactoryBot.create :schedule, queue: :review, reps: 7, due: (Time.now-3.minutes).to_i, ef:2.2, interval:5, konfig_args:{lapse_starting_step: 2, grad_steps:"3 5 7"}
        @s.answer_card 4
      end
      after(:each) do
        Timecop.return
      end
      it "places it in review queue" do
        expect(@s.queue).to eq "review"
      end
      it "sets due to 11 days from now" do
        expect(@s.due).to eq (Time.now + 11.days).to_i
      end
      it "learning step still nil" do
        expect(@s.learning_step).to eq nil
      end
      it "increase reps" do
        expect(@s.reps).to eq 8
      end
      it "interval is 5*2.2 = 11" do
        expect(@s.interval).to eq 11
      end
      it "lapsed is false" do
        expect(@s.lapsed).to eq false
      end
      it "ef is increased" do
        expect(@s.ef).to eq 2.35
      end
    end

    it "EF can't fall below 1.3" do
      @a = FactoryBot.create :schedule, queue: :review, reps: 7, due: (Time.now-3.minutes).to_i, ef:1.35, interval:5, konfig_args:{lapse_starting_step: 2, grad_steps:"3 5 7"}
      @b = FactoryBot.create :schedule, queue: :review, reps: 7, due: (Time.now-3.minutes).to_i, ef:1.35, interval:5, konfig_args:{lapse_starting_step: 2, grad_steps:"3 5 7"}
      @a.answer_card(1)
      @b.answer_card(2)
      expect(@a.ef).to eq 1.3
      expect(@b.ef).to eq 1.3
    end
  end
end

