require 'rails_helper'

module Commentary
  RSpec.describe VersesController, type: :routing do
    describe 'routing' do
      it 'routes GET /commentary/books/:book_slug/chapters/:chapter_number/verses to #index' do
        expect(get: '/commentary/books/genesis/chapters/1/verses').to route_to('commentary/verses#index', book_slug: 'genesis', chapter_number: '1')
      end

      it 'routes GET /commentary/books/:book_slug/chapters/:chapter_number/verses/:numbers to #show' do
        aggregate_failures do
          expect(get: '/commentary/books/genesis/chapters/1/verses/1').to route_to('commentary/verses#show', book_slug: 'genesis', chapter_number: '1', numbers: '1')
          expect(get: '/commentary/books/genesis/chapters/1/verses/1-5').to route_to('commentary/verses#show', book_slug: 'genesis', chapter_number: '1', numbers: '1-5')
          expect(get: '/commentary/books/genesis/chapters/1/verses/1,3,5').to route_to('commentary/verses#show', book_slug: 'genesis', chapter_number: '1', numbers: '1,3,5')
        end
      end
    end
  end
end
