module Commentary
  class BooksController < ApplicationController
    def index
      @translation = Bible::Translation.find_by! code: Settings.bible.defaults.translation
      @books = @translation.books.order(number: :asc)
    end

    def show
      book_slug = params[:slug].to_s.strip

      @translation = Bible::Translation.find_by! code: Settings.bible.defaults.translation
      @book = Bible::Book.find_by! translation: @translation, slug: book_slug

      redirect_to commentary_book_chapters_path(book_slug: @book.slug), status: :temporary_redirect
    end
  end
end
