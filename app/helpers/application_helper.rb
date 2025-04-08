module ApplicationHelper
  def reference_path(target:)
    parsed_target = Bible::Translation.parse_reference(target)
    book_slug = parsed_target[:book]
    chapter_number = parsed_target[:chapter]
    verse_number = parsed_target[:verses]

    translation = Bible::Translation.find_by! code: Settings.bible.defaults.translation
    book = Bible::Book.find_by! translation: translation, code: book_slug

    if verse_number.kind_of?(Array)
      verse_number = parsed_target[:verses][0]
      verse_number = verse_number[0] if verse_number.kind_of?(Array)

      translation_book_chapter_path(translation_code: translation.code.downcase, book_slug: book.slug, number: chapter_number, anchor: "v#{verse_number}")
    else
      translation_book_chapter_path(translation_code: translation.code.downcase, book_slug: book.slug, number: chapter_number)
    end
  end
end
