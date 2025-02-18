require 'rails_helper'

RSpec.describe SearchController, type: :routing do
  describe 'routing' do
    it 'routes GET /search to #index' do
      expect(get: '/search').to route_to('search#index')
    end
  end
end
