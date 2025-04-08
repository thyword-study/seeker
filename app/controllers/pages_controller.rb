class PagesController < ApplicationController
  def home
    @translation = Bible::Translation.find_by! code: Settings.bible.defaults.translation
  end
end
