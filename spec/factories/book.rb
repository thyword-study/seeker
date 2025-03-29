FactoryBot.define do
  factory :book do
    title { Faker::Lorem.word.titlecase }
    number { Faker::Number.between(from: 1, to: 66) }
    code { (0...3).map { ('a'..'z').to_a.sample }.join.upcase }
    slug { Faker::Internet.slug }
    testament { [ "OT", "NT" ].sample }
  end
end
