FactoryBot.define do
  factory :translation_chapter, class: 'Bible::Chapter' do
    number { Faker::Number.between(from: 1, to: 200) }
  end
end
