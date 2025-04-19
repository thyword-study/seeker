require 'rails_helper'

RSpec.describe Bible::Chapter, type: :model do
  let(:translation) { FactoryBot.create(:translation_bsb) }
  let(:book) { FactoryBot.create(:translation_book, translation: translation, title: "Genesis") }

  describe '.group_segments_in_sections' do
    it 'groups chapter segments in sections'
  end

  describe '#full_title' do
    it 'returns the full title' do
      chapter = FactoryBot.create(:translation_chapter, translation: translation, book: book, number: 1)

      expect(chapter.full_title).to eq('Genesis 1')
    end
  end
end
