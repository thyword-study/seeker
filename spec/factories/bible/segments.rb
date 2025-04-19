FactoryBot.define do
  factory :translation_segment, class: 'Bible::Segment' do
    usx_position { Faker::Number.between(from: 1, to: 1000) }
    usx_style { Bible::Segment::CONTENT_STYLES.sample }
  end
end
