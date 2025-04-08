require 'rails_helper'

module Commentary
  RSpec.describe BooksController, type: :request do
    describe 'GET #index' do
      it 'returns the correct response' do
        FactoryBot.create(:translation_bsb)

        get commentary_books_path

        aggregate_failures do
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq 'text/html; charset=utf-8'
        end
      end
    end

    describe 'GET #show' do
      it 'returns the correct response' do
        translation = FactoryBot.create(:translation_bsb)
        book = FactoryBot.create(:translation_book, translation: translation)

        get commentary_book_path slug: book.slug

        aggregate_failures do
          expect(response).to have_http_status(:temporary_redirect)
          expect(response.content_type).to eq 'text/html; charset=utf-8'
        end
      end
    end
  end
end
