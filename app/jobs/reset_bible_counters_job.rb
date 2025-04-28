# Job to reset counters for Bible translations, books, chapters, and verses.
# This job iterates through all Bible translations and resets the counters for
# associated books, chapters, and verses to ensure data consistency.
class ResetBibleCountersJob < ApplicationJob
  queue_as :default

  def perform
    Rails.logger.info "[ResetBibleCountersJob] Starting reset of Bible counters..."

    Bible::Translation.find_each do |translation|
      Rails.logger.info "[ResetBibleCountersJob] Resetting books_count for Translation: #{translation.name} (#{translation.code})"
      Bible::Translation.reset_counters(translation.id, :books)

      translation.books.find_each do |book|
        Rails.logger.info "[ResetBibleCountersJob] Resetting chapters_count for Book: #{book.title} (#{book.code})"
        Bible::Book.reset_counters(book.id, :chapters)

        book.chapters.find_each do |chapter|
          Rails.logger.info "[ResetBibleCountersJob] Resetting verses_count for Chapter: #{book.title} #{chapter.number}"
          Bible::Chapter.reset_counters(chapter.id, :verses)
        end
      end
    end

    Rails.logger.info "[ResetBibleCountersJob] Finished reset of Bible counters."
  end
end
