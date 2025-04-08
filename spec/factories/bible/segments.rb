FactoryBot.define do
  factory :translation_segment, class: 'Bible::Segment' do
    usx_position { Faker::Number.between(from: 1, to: 1000) }
    usx_style { Segment::CONTENT_STYLES.keys.sample }
  end
end
