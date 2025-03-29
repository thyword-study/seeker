FactoryBot.define do
  factory :section do
    position { Faker::Number.number(digits: 1) }
  end
end
