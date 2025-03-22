module Commentary
  class BooksController < ApplicationController
    def index
      @bible = Bible.find_by! code: Settings.bible.defaults.translation
      @books = @bible.books.order(number: :asc)
    end

    def show
      render html: ""
    end
  end
end
