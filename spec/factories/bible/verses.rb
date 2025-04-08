FactoryBot.define do
  factory :translation_verse, class: 'Bible::Verse' do
    number { Faker::Number.between(from: 1, to: 1000) }
  end
end
