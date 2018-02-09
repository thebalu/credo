FactoryBot.define do
  factory :card do
    front "Front of card"
    sequence(:back) { |n| "#{n}" }
    association :deck

    trait :review do
      after(:create) do |card|
        card.schedules.each do |sc|
          sc.queue = "review"
          sc.reps = 8
          sc.interval = 14
          sc.ef= 2.3
          sc.due = (Time.now.beginning_of_day + card.back.to_i.minutes).to_i
        end
      end
    end
  end
end
