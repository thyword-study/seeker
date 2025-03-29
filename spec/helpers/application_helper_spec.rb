require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#reference_path' do
    before(:example) do
      bsb_bible = FactoryBot.create(:bible_bsb)
      FactoryBot.create(:book, bible: bsb_bible, code: 'GEN', slug: 'genesis')
    end

    it 'returns the correct path for a single verse reference' do
      expect(helper.reference_path(target: 'GEN 1:1')).to eq("/bibles/bsb/books/genesis/chapters/1#v1")
    end

    it 'returns the correct path for a chapter reference' do
      expect(helper.reference_path(target: 'GEN 1')).to eq("/bibles/bsb/books/genesis/chapters/1")
    end

    it 'returns the correct path for a range of verses' do
      expect(helper.reference_path(target: 'GEN 1:1-5')).to eq("/bibles/bsb/books/genesis/chapters/1#v1")
    end
  end
end
