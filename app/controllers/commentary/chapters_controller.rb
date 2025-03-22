module Commentary
  class ChaptersController < ApplicationController
    def index
      book_slug = params[:book_slug].to_s.strip

      @bible = Bible.find_by! code: Settings.bible.defaults.translation
      @book = Book.find_by! bible: @bible, slug: book_slug
      @chapters = Chapter.where(bible: @bible, book: @book).order(number: :asc)
    end

    def show
      render html: ""
    end
  end
end
