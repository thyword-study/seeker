require 'rails_helper'

RSpec.describe TranslationsController, type: :routing do
  describe 'routing' do
    it 'routes GET /translations/:code to #show' do
      expect(get: '/translations/bsb').to route_to('translations#show', code: 'bsb')
    end
  end
end
