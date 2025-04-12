module Commentary
  class SectionsController < ApplicationController
    def show
      book_slug = params[:book_slug].to_s.strip
      chapter_number = params[:chapter_number].to_s.strip
      section_id = params[:id].to_s.strip

      @translation = Bible::Translation.find_by! code: Settings.bible.defaults.translation
      @book = Bible::Book.find_by! translation: @translation, slug: book_slug
      @chapter = Bible::Chapter.find_by! translation: @translation, book: @book, number: chapter_number
      @section = Bible::Section.find_by!(translation: @translation, book: @book, chapter: @chapter, id: section_id)
      @verses = @section.segments.map { |segment| segment.verses }.compact.uniq

      @footnotes_mapping = {}
      @footnotes = Bible::Footnote.where(translation: @translation, book: @book, chapter: @chapter, verse: @verses).order(created_at: :asc)
      @footnotes.each.with_index(1) do |footnote, footnote_number|
        footnote_letter = Bible::Footnote.integer_to_letter(footnote_number)

        @footnotes_mapping[footnote.id] = {
          letter: footnote_letter,
          ref_link: "footnote-verse-#{footnote_letter}",
          ref_target: "footnote-#{footnote_letter}",
          verse: footnote.verse&.number
        }
      end
    end
  end
end
