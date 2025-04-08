class PagesController < ApplicationController
  def home
    @bible = Bible.find_by! code: Settings.bible.defaults.translation
  end
end
