FactoryBot.define do
  factory :schedule do
    k=FactoryBot.build :klass
    d=FactoryBot.build :deck, klass: k
    association :card, deck: d
    association :student, klass: k
    #
    # transient do
    #   grad_steps "1 10"
    #   starting_step 1
    # end

    after(:create) do |schedule, evaluator|
      create(:konfig, student: schedule.student, deck:schedule.card.deck)
    end
  end
end
