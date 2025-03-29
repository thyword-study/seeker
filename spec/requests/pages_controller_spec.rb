require 'rails_helper'

RSpec.describe PagesController, type: :request do
  describe 'GET #home' do
    it 'returns the correct response' do
      FactoryBot.create(:bible_bsb)

      get root_path

      aggregate_failures do
        expect(response).to have_http_status(:temporary_redirect)
        expect(response.content_type).to eq 'text/html; charset=utf-8'
      end
    end
  end
end
