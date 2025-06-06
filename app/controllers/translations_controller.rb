class TranslationsController < ApplicationController
  def show
    translation_code = params[:code].to_s.strip.upcase
    translation = Bible::Translation.find_by! code: translation_code

    redirect_to translation_books_url(translation_code: translation.code.downcase), status: :temporary_redirect
  end
end
