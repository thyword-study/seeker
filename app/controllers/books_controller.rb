class BooksController < ApplicationController
  def index
    bible_code = params[:bible_code].to_s.strip.upcase

    @bible = Bible.find_by! code: bible_code
    @books = @bible.books.order(number: :asc)
  end

  def show
    bible_code = params[:bible_code].to_s.strip.upcase
    book_slug = params[:slug].to_s.strip

    @bible = Bible.find_by! code: bible_code
    @book = Book.find_by! bible: @bible, slug: book_slug

    redirect_to bible_book_chapters_url(bible_code: @bible.code.downcase, book_slug: @book.slug), status: :temporary_redirect
  end
end
