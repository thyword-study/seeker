module Commentary
  class ChaptersController < ApplicationController
    def index
      book_slug = params[:book_slug].to_s.strip

      @translation = Bible::Translation.find_by! code: Settings.bible.defaults.translation
      @book = Bible::Book.find_by! translation: @translation, slug: book_slug
      @chapters = Bible::Chapter.where(translation: @translation, book: @book).order(number: :asc)
    end

    def show
      book_slug = params[:book_slug].to_s.strip
      chapter_number = params[:number].to_s.strip

      @translation = Bible::Translation.find_by! code: Settings.bible.defaults.translation
      @book = Bible::Book.find_by! translation: @translation, slug: book_slug
      @chapter = Bible::Chapter.find_by! translation: @translation, book: @book, number: chapter_number
      @sections = Bible::Section.where(translation: @translation, book: @book, chapter: @chapter).order(position: :asc)

      @footnotes_mapping = {}
      @footnotes = Bible::Footnote.where(translation: @translation, book: @book, chapter: @chapter).order(created_at: :asc)
      @footnotes.each.with_index(1) do |footnote, footnote_number|
        footnote_letter = Bible::Footnote.integer_to_letter(footnote_number)

        @footnotes_mapping[footnote.id] = {
          letter: footnote_letter,
          ref_link: "footnote-verse-#{footnote_letter}",
          ref_target: "footnote-#{footnote_letter}",
          verse: footnote.verse&.number
        }
      end
    end
  end
end
