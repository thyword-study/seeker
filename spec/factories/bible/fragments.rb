FactoryBot.define do
  factory :translation_fragment, class: 'Bible::Fragment' do
    content { Faker::Lorem.sentence }
    kind { Fragment.kinds.keys.sample }
    position { Faker::Number.between(from: 1, to: 1000) }
    show_verse { [ true, false ].sample }
  end
end
