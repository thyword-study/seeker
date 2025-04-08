require 'rails_helper'

RSpec.describe ChaptersController, type: :routing do
  describe 'routing' do
    it 'routes GET /translations/:translation_code/books/:book_slug/chapters to #index' do
      expect(get: '/translations/bsb/books/genesis/chapters').to route_to('chapters#index', translation_code: 'bsb', book_slug: 'genesis')
    end

    it 'routes GET /translations/:translation_code/books/:book_slug/chapters/:number to #show' do
      expect(get: '/translations/bsb/books/genesis/chapters/1').to route_to('chapters#show', translation_code: 'bsb', book_slug: 'genesis', number: '1')
    end
  end
end
