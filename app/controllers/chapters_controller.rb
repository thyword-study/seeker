class ChaptersController < ApplicationController
  def index
    bible_code = params[:bible_code].to_s.strip.upcase
    book_slug = params[:book_slug].to_s.strip

    @bible = Bible.find_by! code: bible_code
    @book = Book.find_by! bible: @bible, slug: book_slug
    @chapters = Chapter.where(bible: @bible, book: @book).order(number: :asc)
  end

  def show
    render html: ""
  end
end
