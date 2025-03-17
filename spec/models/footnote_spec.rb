require 'rails_helper'

RSpec.describe Footnote, type: :model do
  describe '.integer_to_letter' do
    it 'returns "a" for 1' do
      expect(Footnote.integer_to_letter(1)).to eq('a')
    end

    it 'returns "z" for 26' do
      expect(Footnote.integer_to_letter(26)).to eq('z')
    end

    it 'returns "aa" for 27' do
      expect(Footnote.integer_to_letter(27)).to eq('aa')
    end

    it 'returns "az" for 52' do
      expect(Footnote.integer_to_letter(52)).to eq('az')
    end

    it 'returns "ba" for 53' do
      expect(Footnote.integer_to_letter(53)).to eq('ba')
    end

    it 'returns "zz" for 702' do
      expect(Footnote.integer_to_letter(702)).to eq('zz')
    end

    it 'returns "aaa" for 703' do
      expect(Footnote.integer_to_letter(703)).to eq('aaa')
    end

    it 'returns "aab" for 704' do
      expect(Footnote.integer_to_letter(704)).to eq('aab')
    end
  end
end
