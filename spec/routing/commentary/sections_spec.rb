require 'rails_helper'

module Commentary
  RSpec.describe SectionsController, type: :routing do
    describe 'routing' do
      it 'routes GET /commentary/books/:book_slug/chapters/:chapter_number/sections/:id to #show' do
        expect(get: '/commentary/books/genesis/chapters/1/sections/1').to route_to('commentary/sections#show', book_slug: 'genesis', chapter_number: '1', id: '1')
      end
    end
  end
end
