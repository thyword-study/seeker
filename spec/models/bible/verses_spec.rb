require 'rails_helper'

RSpec.describe Bible::Verse, type: :model do
  let(:translation) { FactoryBot.create(:translation_bsb) }
  let(:book) { FactoryBot.create(:translation_book, translation: translation, title: "Genesis") }
  let(:chapter) { FactoryBot.create(:translation_chapter, translation: translation, book: book, number: 1) }

  describe '#next_number' do
    context 'when the verse is the last verse in the chapter' do
      it 'returns nil' do
        FactoryBot.create(:translation_verse, translation: translation, book: book, chapter: chapter, number: 1)
        verse = FactoryBot.create(:translation_verse, translation: translation, book: book, chapter: chapter, number: 2)

        expect(verse.next_number).to be_nil
      end
    end

    context 'when the verse is not the last verse in the chapter' do
      it 'returns the next verse number' do
        verse = FactoryBot.create(:translation_verse, translation: translation, book: book, chapter: chapter, number: 1)
        FactoryBot.create(:translation_verse, translation: translation, book: book, chapter: chapter, number: 2)

        expect(verse.next_number).to eq(2)
      end
    end
  end

  describe '.format_verse_numbers' do
    it 'returns correctly formatted verse numbers' do
      aggregate_failures do
        expect(Bible::Verse.format_verse_numbers([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ])).to eq('1-10')
        expect(Bible::Verse.format_verse_numbers([ 1, 4, 5, 6, 9, 10 ])).to eq('1,4-6,9,10')
        expect(Bible::Verse.format_verse_numbers([ 1, 2, 3, 8, 9, 10 ])).to eq('1-3,8-10')
        expect(Bible::Verse.format_verse_numbers([ 1, 3, 5, 6 ])).to eq('1,3,5,6')
        expect(Bible::Verse.format_verse_numbers([ 1, 1 ])).to eq('1')
      end
    end
  end
end
