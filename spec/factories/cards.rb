FactoryBot.define do
  factory :card do
    front "Front of card"
    back "Back of card"
    association :deck
  end
end
