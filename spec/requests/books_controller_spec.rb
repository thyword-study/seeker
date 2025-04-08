require 'rails_helper'

RSpec.describe BooksController, type: :request do
  describe 'GET #index' do
    it 'returns the correct response' do
      translation = FactoryBot.create(:translation)

      get translation_books_path translation_code: translation.code.downcase

      aggregate_failures do
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq 'text/html; charset=utf-8'
      end
    end
  end

  describe 'GET #show' do
    it 'returns the correct response' do
      translation = FactoryBot.create(:translation)
      book = FactoryBot.create(:translation_book, translation: translation)

      get translation_book_path translation_code: translation.code.downcase, slug: book.slug

      aggregate_failures do
        expect(response).to have_http_status(:temporary_redirect)
        expect(response.content_type).to eq 'text/html; charset=utf-8'
      end
    end
  end
end
