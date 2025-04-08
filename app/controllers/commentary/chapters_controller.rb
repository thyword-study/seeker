module Commentary
  class ChaptersController < ApplicationController
    def index
      book_slug = params[:book_slug].to_s.strip

      @bible = Bible.find_by! code: Settings.bible.defaults.translation
      @book = Book.find_by! bible: @bible, slug: book_slug
      @chapters = Chapter.where(bible: @bible, book: @book).order(number: :asc)
    end

    def show
      book_slug = params[:book_slug].to_s.strip
      chapter_number = params[:number].to_s.strip

      @bible = Bible.find_by! code: Settings.bible.defaults.translation
      @book = Book.find_by! bible: @bible, slug: book_slug
      @chapter = Chapter.find_by! bible: @bible, book: @book, number: chapter_number
      @sections = Section.where(bible: @bible, book: @book, chapter: @chapter).order(position: :asc)

      @footnotes_mapping = {}
      @footnotes = Footnote.where(bible: @bible, book: @book, chapter: @chapter).order(created_at: :asc)
      @footnotes.each.with_index(1) do |footnote, footnote_number|
        footnote_letter = Footnote.integer_to_letter(footnote_number)

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
