class PagesController < ApplicationController
  def home
    bible = Bible.find_by! code: Settings.bible.defaults.translation

    redirect_to bible_url(code: bible.code.downcase), status: :temporary_redirect
  end
end
