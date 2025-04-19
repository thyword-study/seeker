FactoryBot.define do
  factory :exposition_content, class: 'Exposition::Content' do
    context { Faker::Lorem.paragraph }
    highlights { Faker::Lorem.paragraphs }
    interpretation_type { Exposition::Content.interpretation_types.keys.sample }
    people { Faker::Lorem.words }
    places { Faker::Lorem.words }
    reflections { Faker::Lorem.paragraphs }
    summary { Faker::Lorem.paragraph }
    tags { Faker::Lorem.words }
  end
end
