require 'rails_helper'

module Commentary
  RSpec.describe BooksController, type: :request do
    describe 'GET #index' do
      it 'returns the correct response' do
        bible = FactoryBot.create(:bible_bsb)
        book = FactoryBot.create(:book, bible: bible)

        get commentary_book_chapters_path book_slug: book.slug

        aggregate_failures do
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq 'text/html; charset=utf-8'
        end
      end
    end

    describe 'GET #show' do
      it 'returns the correct response' do
        bible = FactoryBot.create(:bible_bsb)
        book = FactoryBot.create(:book, bible: bible)
        chapter = FactoryBot.create(:chapter, bible: bible, book: book, number: 1)

        get commentary_book_chapter_path book_slug: book.slug, number: chapter.number

        aggregate_failures do
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq 'text/html; charset=utf-8'
        end
      end
    end
  end
end
