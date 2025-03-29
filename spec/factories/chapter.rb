FactoryBot.define do
  factory :chapter do
    number { Faker::Number.between(from: 1, to: 200) }
  end
end
