FactoryBot.define do
  factory :translation_footnote, class: 'Bible::Footnote' do
    content { Faker::Lorem.sentence }
  end
end
