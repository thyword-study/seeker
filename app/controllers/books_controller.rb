class BooksController < ApplicationController
  def index
    bible_code = params[:bible_code].to_s.strip.upcase

    @bible = Bible.find_by! code: bible_code
    @books = @bible.books.order(number: :asc)
  end

  def show
    render html: ""
  end
end
