require 'rails_helper'

RSpec.describe Bible::Chapter, type: :model do
  let(:translation) { FactoryBot.create(:translation_bsb) }
  let(:book) { FactoryBot.create(:translation_book, translation: translation, title: "Genesis") }

  describe '.group_segments_in_sections' do
    it 'groups chapter segments in sections'
  end

  describe '#exposit' do
    it 'creates a batch request for the chapter exposition' do
      system_prompt = FactoryBot.create :exposition_system_prompt, text: <<~HEREDOC.strip
        You are an AI providing commentary on texts from the Bible.
      HEREDOC
      chapter = FactoryBot.create(:translation_chapter, translation: translation, book: book, number: 1)
      heading = FactoryBot.create(:translation_heading, translation: translation, book: book, chapter: chapter)
      section = FactoryBot.create(:translation_section, translation: translation, book: book, chapter: chapter, heading: heading, position: 1)
      segment = FactoryBot.create(:translation_segment, translation: translation, book: book, chapter: chapter, heading: heading, usx_position: 6, usx_style: 'm')
      verse = FactoryBot.create(:translation_verse, translation: translation, book: book, chapter: chapter, number: 1)
      FactoryBot.create(:translation_fragment, translation: translation, book: book, chapter: chapter, heading: heading, segment: segment, verse: verse, content: "In the beginning God created the heavens and the earth.", position: 1, show_verse: true, kind: "text")
      section.segments << segment

      batch_request = chapter.exposit(system_prompt)

      aggregate_failures do
        expect(batch_request).to be_a(Exposition::BatchRequest)
        expect {
          Exposit::ProcessBatchRequestJob.perform_later(batch_request.id)
        }.to have_enqueued_job(Exposit::ProcessBatchRequestJob).with(batch_request.id)
      end
    end
  end

  describe '#full_title' do
    it 'returns the full title' do
      chapter = FactoryBot.create(:translation_chapter, translation: translation, book: book, number: 1)

      expect(chapter.full_title).to eq('Genesis 1')
    end
  end

  describe '#title' do
    it 'returns the chapter title' do
      chapter = FactoryBot.create(:translation_chapter, translation: translation, book: book, number: 1)

      expect(chapter.title).to eq('Chapter 1')
    end
  end
end
