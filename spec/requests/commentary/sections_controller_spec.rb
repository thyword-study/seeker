require 'rails_helper'

module Commentary
  RSpec.describe SectionsController, type: :request do
    describe 'GET #show' do
    it 'returns the correct response' do
      translation = FactoryBot.create(:translation_bsb)
      book = FactoryBot.create(:translation_book, translation: translation)
      chapter = FactoryBot.create(:translation_chapter, translation: translation, book: book, number: 1)
      heading = FactoryBot.create(:translation_heading, translation: translation, book: book, chapter: chapter)
      section = FactoryBot.create(:translation_section, translation: translation, book: book, chapter: chapter, heading: heading, position: 1)

      batch_request = FactoryBot.create(:exposition_batch_request)
      system_prompt = FactoryBot.create :exposition_system_prompt
      user_prompt = FactoryBot.create :exposition_user_prompt, id: 2, batch_request: batch_request, system_prompt: system_prompt, section: section
      FactoryBot.create(:exposition_content, section: section, user_prompt: user_prompt)

      get commentary_book_chapter_section_path book_slug: book.slug, chapter_number: chapter.number, id: section.id

      aggregate_failures do
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq 'text/html; charset=utf-8'
      end
    end
    end
  end
end
