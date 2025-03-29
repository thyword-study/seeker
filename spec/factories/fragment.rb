FactoryBot.define do
  factory :fragment do
    content { Faker::Lorem.sentence }
    kind { Fragment.kinds.keys.sample }
    position { Faker::Number.between(from: 1, to: 1000) }
    show_verse { [ true, false ].sample }
  end
end
