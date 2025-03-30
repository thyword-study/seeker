FactoryBot.define do
  factory :verse do
    number { Faker::Number.between(from: 1, to: 1000) }
  end
end
