require 'rails_helper'

RSpec.describe ChaptersController, type: :routing do
  describe 'routing' do
    it 'routes GET /bibles/:bible_code/books/:book_slug/chapters to #index' do
      expect(get: '/bibles/bsb/books/genesis/chapters').to route_to('chapters#index', bible_code: 'bsb', book_slug: 'genesis')
    end

    it 'routes GET /bibles/:bible_code/books/:book_slug/chapters/:number to #show' do
      expect(get: '/bibles/bsb/books/genesis/chapters/1').to route_to('chapters#show', bible_code: 'bsb', book_slug: 'genesis', number: '1')
    end
  end
end
