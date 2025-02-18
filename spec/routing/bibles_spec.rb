require 'rails_helper'

RSpec.describe BiblesController, type: :routing do
  describe 'routing' do
    it 'routes GET /bibles/:code to #show' do
      expect(get: '/bibles/BSB').to route_to('bibles#show', code: 'BSB')
    end
  end
end
