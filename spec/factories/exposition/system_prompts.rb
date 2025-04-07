FactoryBot.define do
  factory :exposition_system_prompt, class: 'Exposition::SystemPrompt' do
    text { Faker::Lorem.paragraph(sentence_count: 2, supplemental: true, random_sentences_to_add: 100) }
  end
end
