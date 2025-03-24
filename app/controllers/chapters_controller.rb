class ChaptersController < ApplicationController
  def index
    bible_code = params[:bible_code].to_s.strip.upcase
    book_slug = params[:book_slug].to_s.strip

    @bible = Bible.find_by! code: bible_code
    @book = Book.find_by! bible: @bible, slug: book_slug
    @chapters = Chapter.where(bible: @bible, book: @book).order(number: :asc)
  end

  def show
    bible_code = params[:bible_code].to_s.strip.upcase
    book_slug = params[:book_slug].to_s.strip
    chapter_number = params[:number].to_s.strip

    @bible = Bible.find_by! code: bible_code
    @book = Book.find_by! bible: @bible, slug: book_slug
    @chapter = Chapter.find_by! bible: @bible, book: @book, number: chapter_number

    segments = Segment.where(bible: @bible, book: @book, chapter: @chapter).where.not(usx_style: "b").order(usx_node_id: :asc)
    @sectioned_segments = Segment.group_in_sections(segments)

    @footnotes_mapping = {}
    @footnotes = Footnote.where(bible: @bible, book: @book, chapter: @chapter).order(created_at: :asc)
    @footnotes.each.with_index(1) do |footnote, footnote_number|
      footnote_letter = Footnote.integer_to_letter(footnote_number)

      @footnotes_mapping[footnote.id] = {
        letter: footnote_letter,
        ref_link: "footnote-verse-#{footnote_letter}",
        ref_target: "footnote-#{footnote_letter}",
        verse: footnote.verse&.number
      }
    end
  end
end
