require 'rails_helper'

module Commentary
  RSpec.describe BooksController, type: :routing do
    describe 'routing' do
      it 'routes GET /commentary/books to #index' do
        expect(get: '/commentary/books').to route_to('commentary/books#index')
      end

      it 'routes GET /commentary/books/:slug to #show' do
        expect(get: '/commentary/books/genesis').to route_to('commentary/books#show', slug: 'genesis')
      end
    end
  end
end
