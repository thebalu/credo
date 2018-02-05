FactoryBot.define do
  factory :schedule do
    k=FactoryBot.build :klass
    d=FactoryBot.build :deck, klass: k
    association :card, deck: d
    association :student, klass: k
    queue "unseen"
    lapsed false
  end
end
