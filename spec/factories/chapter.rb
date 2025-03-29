FactoryBot.define do
  factory :chapter do
    number { Faker::Number.between(from: 1, to: 50) }
  end
end
