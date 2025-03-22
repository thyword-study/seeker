module Commentary
  class BooksController < ApplicationController
    def index
      @bible = Bible.find_by! code: Settings.bible.defaults.translation
      @books = @bible.books.order(number: :asc)
    end

    def show
      book_slug = params[:slug].to_s.strip

      @bible = Bible.find_by! code: Settings.bible.defaults.translation
      @book = Book.find_by! bible: @bible, slug: book_slug

      redirect_to commentary_book_chapters_path(book_slug: @book.slug), status: :temporary_redirect
    end
  end
end
