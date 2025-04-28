require 'rails_helper'

RSpec.describe Bible::Book, type: :model do
  let(:translation) { FactoryBot.create(:translation_bsb) }

  describe '#next_number' do
    context 'when the book is the last book in the translation' do
      it 'returns nil' do
        FactoryBot.create(:translation_book, translation: translation, number: 1)
        book = FactoryBot.create(:translation_book, translation: translation, number: 2)

        expect(book.next_number).to be_nil
      end
    end

    context 'when the book is not the last book in the translation' do
      it 'returns the next book number' do
        book = FactoryBot.create(:translation_book, translation: translation, number: 1)
        FactoryBot.create(:translation_book, translation: translation, number: 2)

        expect(book.next_number).to eq(2)
      end
    end
  end
end
