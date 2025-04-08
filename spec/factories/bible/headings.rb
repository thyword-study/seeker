FactoryBot.define do
  factory :translation_heading, class: 'Bible::Heading' do
    kind { Bible::Heading.kinds.keys.sample }
    level { Faker::Number.digit }
    title  { Faker::Lorem.word.titlecase }
  end
end
