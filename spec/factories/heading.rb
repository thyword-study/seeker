FactoryBot.define do
  factory :heading do
    kind { Heading.kinds.keys.sample }
    level { Faker::Number.digit }
    title  { Faker::Lorem.word.titlecase }
  end
end
