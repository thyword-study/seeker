FactoryBot.define do
  factory :exposition_batch_request, class: 'Exposition::BatchRequest' do
    name { Faker::Lorem.words.join(" ").titlecase }
    status { "requested" }
  end
end
