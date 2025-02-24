require 'rails_helper'

RSpec.describe Bible, type: :model do
  describe '.parse_reference' do
    it 'parses a valid bible reference' do
      reference = "JHN 3:16-18"
      result = Bible.parse_reference(reference)
      expect(result).to eq({ book: "JHN", chapter: 3, verses: [ [ 16, 18 ] ] })
    end

    it 'parses a reference with multiple verses' do
      reference = "ROM 5:12,15-17"
      result = Bible.parse_reference(reference)
      expect(result).to eq({ book: "ROM", chapter: 5, verses: [ 12, [ 15, 17 ] ] })
    end

    it 'returns nil for invalid reference' do
      reference = "INVALID REF"
      result = Bible.parse_reference(reference)
      expect(result).to be_nil
    end
  end
end
