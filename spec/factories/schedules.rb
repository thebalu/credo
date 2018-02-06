FactoryBot.define do
  factory :schedule do
    k=FactoryBot.build :klass
    d=FactoryBot.build :deck, klass: k
    association :card, deck: d
    association :student, klass: k

    transient do
      grad_steps "1 10"
      konfig_args Hash.new
    end

    after(:create) do |schedule, evaluator|
      default = {deck_id:schedule.card.deck_id, student_id:schedule.student_id}
      ap evaluator.konfig_args
      opt=default.merge evaluator.konfig_args
      create(:konfig,  opt)
    end
  end
end
