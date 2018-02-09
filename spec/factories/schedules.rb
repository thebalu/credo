FactoryBot.define do
  factory :schedule do
    k=FactoryBot.create :klass
    d=FactoryBot.create :deck, klass: k
    association :card, deck: d
    association :student, klass: k

    trait :review_due_today do
      queue "review"
      due {(Time.now.end_of_day - 3.hours).to_i}
      interval 14
      ef 2.15
      reps 6
    end

    transient do
      # grad_steps "1 10"
      konfig_args Hash.new
    end

    after(:create) do |schedule, evaluator|
      default = {deck:schedule.card.deck, student:schedule.student}
      # ap evaluator.konfig_args
      opt=default.merge evaluator.konfig_args
      create(:konfig,  opt)
    end


  end
end
