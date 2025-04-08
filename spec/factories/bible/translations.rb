FactoryBot.define do
  factory :translation, class: 'Bible::Translation' do
    code { (0...3).map { ('a'..'z').to_a.sample }.join.upcase }
    name { Faker::Lorem.word.titlecase }
    rights_holder_name { Faker::Company.name }
    rights_holder_url { Faker::Internet.url }
    statement { Faker::Lorem.sentence }
  end

  factory :translation_bsb, parent: :translation do
    code { "BSB" }
    name { "Berean Standard Bible" }
  end
end
