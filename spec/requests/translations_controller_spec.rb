require 'rails_helper'

RSpec.describe TranslationsController, type: :request do
  describe 'GET #show' do
    it 'returns the correct response' do
      translation = FactoryBot.create(:translation)

      get translation_path code: translation.code.downcase

      aggregate_failures do
        expect(response).to have_http_status(:temporary_redirect)
        expect(response.content_type).to eq 'text/html; charset=utf-8'
      end
    end
  end
end
