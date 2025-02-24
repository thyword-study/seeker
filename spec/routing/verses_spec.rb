require 'rails_helper'

RSpec.describe VersesController, type: :routing do
  describe 'routing' do
    it 'routes GET /bibles/:bible_code/books/:book_slug/chapters/:chapter_number/verses to #index' do
      expect(get: '/bibles/bsb/books/genesis/chapters/1/verses').to route_to('verses#index', bible_code: 'bsb', book_slug: 'genesis', chapter_number: '1')
    end

    it 'routes GET /bibles/:bible_code/books/:book_slug/chapters/:chapter_number/verses/:numbers to #show' do
      aggregate_failures do
        expect(get: '/bibles/bsb/books/genesis/chapters/1/verses/1').to route_to('verses#show', bible_code: 'bsb', book_slug: 'genesis', chapter_number: '1', numbers: '1')
        expect(get: '/bibles/bsb/books/genesis/chapters/1/verses/1-5').to route_to('verses#show', bible_code: 'bsb', book_slug: 'genesis', chapter_number: '1', numbers: '1-5')
        expect(get: '/bibles/bsb/books/genesis/chapters/1/verses/1,3,5').to route_to('verses#show', bible_code: 'bsb', book_slug: 'genesis', chapter_number: '1', numbers: '1,3,5')
      end
    end
  end
end
