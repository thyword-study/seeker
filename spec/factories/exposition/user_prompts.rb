FactoryBot.define do
  factory :exposition_user_prompt, class: 'Exposition::UserPrompt' do
    text { Faker::Lorem.paragraph(sentence_count: 2, supplemental: true, random_sentences_to_add: 10) }
  end
end
