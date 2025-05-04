require 'rails_helper'

module Commentary
  RSpec.describe SectionsController, type: :routing do
    describe 'routing' do
      it 'routes GET /commentary/books/:book_slug/chapters/:chapter_number/sections/:verse_spec to #show' do
        expect(get: '/commentary/books/genesis/chapters/1/sections/1').to route_to('commentary/sections#show', book_slug: 'genesis', chapter_number: '1', verse_spec: '1')
      end

      it 'routes GET /commentary/books/:book_slug/chapters/:chapter_number/sections/:verse_spec to #show' do
        expect(get: '/commentary/books/genesis/chapters/1/sections/1,2').to route_to('commentary/sections#show', book_slug: 'genesis', chapter_number: '1', verse_spec: '1,2')
      end

      it 'routes GET /commentary/books/:book_slug/chapters/:chapter_number/sections/:verse_spec to #show' do
        expect(get: '/commentary/books/genesis/chapters/1/sections/1-3').to route_to('commentary/sections#show', book_slug: 'genesis', chapter_number: '1', verse_spec: '1-3')
      end
    end
  end
end
