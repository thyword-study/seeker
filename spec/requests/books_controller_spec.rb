require 'rails_helper'

RSpec.describe BooksController, type: :request do
  describe 'GET #index' do
    it 'returns the correct response' do
      bible = FactoryBot.create(:bible)

      get bible_books_path bible_code: bible.code.downcase

      aggregate_failures do
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq 'text/html; charset=utf-8'
      end
    end
  end

  describe 'GET #show' do
    it 'returns the correct response' do
      bible = FactoryBot.create(:bible)
      book = FactoryBot.create(:book, bible: bible)

      get bible_book_path bible_code: bible.code.downcase, slug: book.slug

      aggregate_failures do
        expect(response).to have_http_status(:temporary_redirect)
        expect(response.content_type).to eq 'text/html; charset=utf-8'
      end
    end
  end
end
