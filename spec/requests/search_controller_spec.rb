require 'rails_helper'

RSpec.describe SearchController, type: :request do
  describe 'GET #index' do
    it 'returns the correct response' do
      get search_path

      aggregate_failures do
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq 'text/html; charset=utf-8'
      end
    end
  end
end
