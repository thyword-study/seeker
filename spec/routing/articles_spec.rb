require 'rails_helper'

RSpec.describe ArticlesController, type: :routing do
  describe 'routing' do
    it 'routes GET /articles to #index' do
      expect(get: '/articles').to route_to('articles#index')
    end

    it 'routes GET /articles/:slug to #show' do
      expect(get: '/articles/faith-in-action').to route_to('articles#show', slug: 'faith-in-action')
    end
  end
end
