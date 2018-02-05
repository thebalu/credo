FactoryBot.define do
  factory :deck do
    sequence(:name) { |n| "Deck #{n}" }
    description "This is a top deck."
    klass
  end
end
