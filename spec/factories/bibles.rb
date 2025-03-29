FactoryBot.define do
  factory :bible do
    name { Faker::Lorem.word.titlecase }
    code { (0...3).map { ('a'..'z').to_a.sample }.join.upcase }
    rights_holder_name { Faker::Company.name }
    rights_holder_url { Faker::Internet.url }
    statement { Faker::Lorem.sentence }
  end

  factory :bible_bsb, parent: :bible do
    name { "Berean Standard Bible" }
    code { "BSB" }
  end
end
