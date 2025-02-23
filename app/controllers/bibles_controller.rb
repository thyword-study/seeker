class BiblesController < ApplicationController
  def show
    bible_code = params[:code].to_s.strip.upcase
    bible = Bible.find_by! code: bible_code

    redirect_to bible_books_url(bible_code: bible.code.downcase), status: :temporary_redirect
  end
end
