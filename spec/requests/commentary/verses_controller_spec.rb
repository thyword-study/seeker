require 'rails_helper'

module Commentary
  RSpec.describe VersesController, type: :request do
    describe 'GET #index' do
      it 'returns the correct response' do
        get commentary_book_chapter_verses_path book_slug: "genesis", chapter_number: "1"

        aggregate_failures do
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq 'text/html; charset=utf-8'
        end
      end
    end

    describe 'GET #show' do
      context "when it's one verse" do
        it 'returns the correct response' do
          get commentary_book_chapter_verse_path book_slug: 'genesis', chapter_number: "1", numbers: "1"

          aggregate_failures do
            expect(response).to have_http_status(:ok)
            expect(response.content_type).to eq 'text/html; charset=utf-8'
          end
        end
      end

      context "when it's a range of verses" do
        it 'returns the correct response' do
          get commentary_book_chapter_verse_path book_slug: 'genesis', chapter_number: "1", numbers: "1-5"

          aggregate_failures do
            expect(response).to have_http_status(:ok)
            expect(response.content_type).to eq 'text/html; charset=utf-8'
          end
        end
      end

      context "when it's multiple separate verses" do
        it 'returns the correct response' do
          get commentary_book_chapter_verse_path book_slug: 'genesis', chapter_number: "1", numbers: "1,3,5"

          aggregate_failures do
            expect(response).to have_http_status(:ok)
            expect(response.content_type).to eq 'text/html; charset=utf-8'
          end
        end
      end
    end
  end
end
