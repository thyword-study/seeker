require 'rails_helper'

RSpec.describe BooksController, type: :routing do
  describe 'routing' do
    it 'routes GET /bibles/:bible_code/books to #index' do
      expect(get: '/bibles/bsb/books').to route_to('books#index', bible_code: 'bsb')
    end

    it 'routes GET /bibles/:bible_code/books/:slug to #show' do
      expect(get: '/bibles/bsb/books/genesis').to route_to('books#show', bible_code: 'bsb', slug: 'genesis')
    end
  end
end
