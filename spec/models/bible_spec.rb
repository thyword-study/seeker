require 'rails_helper'

RSpec.describe Bible, type: :model do
  describe '.parse_reference' do
    it 'parses a valid verse reference with a specific verse' do
      reference = "GEN 1:1"
      result = Bible.parse_reference(reference)
      expect(result).to eq({ book: "GEN", chapter: 1, verses: [ 1 ] })
    end

    it 'parses a valid verse reference with a range of verses' do
      reference = "JHN 3:16-18"
      result = Bible.parse_reference(reference)
      expect(result).to eq({ book: "JHN", chapter: 3, verses: [ [ 16, 18 ] ] })
    end

    it 'parses a valid verse reference with multiple verse specifications' do
      reference = "ROM 5:12,15-17"
      result = Bible.parse_reference(reference)
      expect(result).to eq({ book: "ROM", chapter: 5, verses: [ 12, [ 15, 17 ] ] })
    end

    it 'parses a valid chapter reference' do
      reference = "PSA 1-41"
      result = Bible.parse_reference(reference)
      expect(result).to eq({ book: "PSA", chapter: 1, verses: nil })
    end

    it 'returns nil for invalid reference' do
      reference = "INVALID REF"
      result = Bible.parse_reference(reference)
      expect(result).to be_nil
    end
  end
end
