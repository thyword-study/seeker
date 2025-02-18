require 'rails_helper'

RSpec.describe BiblesController, type: :request do
  describe 'GET #show' do
    it 'returns the correct response' do
      get bible_path code: 'BSB'

      aggregate_failures do
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq 'text/html; charset=utf-8'
      end
    end
  end
end
