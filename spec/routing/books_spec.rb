require 'rails_helper'

RSpec.describe BooksController, type: :routing do
  describe 'routing' do
    it 'routes GET /translations/:translation_code/books to #index' do
      expect(get: '/translations/bsb/books').to route_to('books#index', translation_code: 'bsb')
    end

    it 'routes GET /translations/:translation_code/books/:slug to #show' do
      expect(get: '/translations/bsb/books/genesis').to route_to('books#show', translation_code: 'bsb', slug: 'genesis')
    end
  end
end
