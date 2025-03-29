FactoryBot.define do
  factory :footnote do
    content { Faker::Lorem.sentence }
  end
end
