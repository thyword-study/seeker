FactoryBot.define do
  factory :translation_section, class: 'Bible::Section' do
    position { Faker::Number.number(digits: 1) }
  end
end
