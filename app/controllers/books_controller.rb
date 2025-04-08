class BooksController < ApplicationController
  def index
    translation_code = params[:translation_code].to_s.strip.upcase

    @translation = Bible::Translation.find_by! code: translation_code
    @books = @translation.books.order(number: :asc)
  end

  def show
    translation_code = params[:translation_code].to_s.strip.upcase
    book_slug = params[:slug].to_s.strip

    @translation = Bible::Translation.find_by! code: translation_code
    @book = Bible::Book.find_by! translation: @translation, slug: book_slug

    redirect_to translation_book_chapters_url(translation_code: @translation.code.downcase, book_slug: @book.slug), status: :temporary_redirect
  end
end
