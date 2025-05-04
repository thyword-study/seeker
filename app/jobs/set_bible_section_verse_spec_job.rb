class SetBibleSectionVerseSpecJob < ApplicationJob
  queue_as :default

  def perform
    Rails.logger.info "[SetBibleSectionVerseSpecJob] Starting setting of Bible section verse-specs..."

    Bible::Translation.find_each do |translation|
      Rails.logger.info "[SetBibleSectionVerseSpecJob] Set section verse-spec for Translation: #{translation.name} (#{translation.code})"

      translation.books.find_each do |book|
        Rails.logger.info "[SetBibleSectionVerseSpecJob] Set section verse-spec for Book: #{book.title} (#{book.code})"

        book.chapters.find_each do |chapter|
          Rails.logger.info "[SetBibleSectionVerseSpecJob] Set section verse-spec for Chapter: #{book.title} #{chapter.number}"

            sections = Bible::Section.where(translation: translation, book: book, chapter: chapter).order(position: :asc)
            sections.each do |section|
              verse_spec = section.generate_verse_spec

              next unless verse_spec

              section.update! verse_spec: verse_spec
              Rails.logger.info "[SetBibleSectionVerseSpecJob] Set section verse-spec for Section: #{section.id} (with verse_spec #{verse_spec})"
            end
        end
      end
    end

    Rails.logger.info "[SetBibleSectionVerseSpecJob] Finished setting of Bible section verse-specs."
  end
end
