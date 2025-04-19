require 'rails_helper'

RSpec.describe Bible::Verse, type: :model do
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
