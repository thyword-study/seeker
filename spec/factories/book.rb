FactoryBot.define do
  factory :book do
    code { (0...3).map { ('a'..'z').to_a.sample }.join.upcase }
    number { Faker::Number.between(from: 1, to: 66) }
    slug { Faker::Internet.slug }
    testament { [ "OT", "NT" ].sample }
    title { Faker::Lorem.word.titlecase }
  end
end
