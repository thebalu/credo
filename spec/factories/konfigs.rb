FactoryBot.define do
  factory :konfig do
    k=FactoryBot.build :klass
    association :deck, klass: k
    association :student, klass: k
    grad_steps "1 10"
    starting_step 1

  end
end
