require 'rails_helper'

RSpec.describe ArticlesController, type: :request do
  describe 'GET #index' do
    it 'returns the correct response' do
      get articles_path

      aggregate_failures do
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq 'text/html; charset=utf-8'
      end
    end
  end

  describe 'GET #show' do
    it 'returns the correct response' do
      get article_path slug: 'faith-in-action'

      aggregate_failures do
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq 'text/html; charset=utf-8'
      end
    end
  end
end
