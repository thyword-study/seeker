require 'rails_helper'

module Commentary
  RSpec.describe ChaptersController, type: :routing do
    describe 'routing' do
      it 'routes GET /commentary/books/:book_slug/chapters to #index' do
        expect(get: '/commentary/books/genesis/chapters').to route_to('commentary/chapters#index', book_slug: 'genesis')
      end

      it 'routes GET /commentary/books/:book_slug/chapters/:number to #show' do
        expect(get: '/commentary/books/genesis/chapters/1').to route_to('commentary/chapters#show', book_slug: 'genesis', number: '1')
      end
    end
  end
end
