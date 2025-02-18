require 'rails_helper'

RSpec.describe BooksController, type: :request do
  describe 'GET #index' do
    it 'returns the correct response' do
      get bible_book_chapters_path bible_code: 'BSB', book_slug: "genesis"

      aggregate_failures do
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq 'text/html; charset=utf-8'
      end
    end
  end

  describe 'GET #show' do
    it 'returns the correct response' do
      get bible_book_chapter_path bible_code: 'BSB', book_slug: 'genesis', number: "1"

      aggregate_failures do
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq 'text/html; charset=utf-8'
      end
    end
  end
end
