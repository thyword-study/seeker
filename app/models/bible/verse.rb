# ## Schema Information
#
# Table name: `bible_verses`
#
# ### Columns
#
# Name                  | Type               | Attributes
# --------------------- | ------------------ | ---------------------------
# **`id`**              | `bigint`           | `not null, primary key`
# **`number`**          | `integer`          | `not null`
# **`created_at`**      | `datetime`         | `not null`
# **`updated_at`**      | `datetime`         | `not null`
# **`book_id`**         | `bigint`           | `not null`
# **`chapter_id`**      | `bigint`           | `not null`
# **`translation_id`**  | `bigint`           | `not null`
#
# ### Indexes
#
# * `idx_on_translation_id_book_id_chapter_id_number_3c298a7c72` (_unique_):
#     * **`translation_id`**
#     * **`book_id`**
#     * **`chapter_id`**
#     * **`number`**
# * `index_bible_verses_on_book_id`:
#     * **`book_id`**
# * `index_bible_verses_on_chapter_id`:
#     * **`chapter_id`**
# * `index_bible_verses_on_translation_id`:
#     * **`translation_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...` (_ON DELETE => restrict_):
#     * **`book_id => bible_books.id`**
# * `fk_rails_...` (_ON DELETE => restrict_):
#     * **`chapter_id => bible_chapters.id`**
# * `fk_rails_...` (_ON DELETE => restrict_):
#     * **`translation_id => bible_translations.id`**
#
class Bible::Verse < ApplicationRecord
  # Associations
  belongs_to :book
  belongs_to :chapter, counter_cache: true
  belongs_to :translation
  has_many :footnotes, dependent: :restrict_with_error
  has_many :fragments, dependent: :restrict_with_error
  has_many :segment_verse_associations, dependent: :destroy
  has_many :segments, through: :segment_verse_associations

  # Validations
  validates :book, presence: true
  validates :chapter, presence: true
  validates :number, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :translation, presence: true

  # Returns the number of the next verse in the chapter, or `nil` if the current
  # verse is the last one in the chapter.
  #
  # @return [Integer, nil] The number of the next verse, or `nil` if there is no
  #   next verse.
  def next_number
    if number == chapter.verses_count
      nil
    else
      number + 1
    end
  end

  # Formats an array of verse numbers into a compact string representation.
  #
  # Consecutive numbers are grouped into ranges (e.g., "1-10"), while
  # non-consecutive numbers are separated by commas (e.g., "1,4-6,9,10").
  #
  # @param numbers [Array<Integer>] An array of verse numbers to format.
  # @return [String] A formatted string representing the verse numbers.
  #
  # @example
  #   Bible::Verse.format_verse_numbers([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
  #   # => "1-10"
  #
  #   Bible::Verse.format_verse_numbers([1, 4, 5, 6, 9, 10])
  #   # => "1,4-6,9,10"
  #
  #   Bible::Verse.format_verse_numbers([1, 2, 3, 8, 9, 10])
  #   # => "1-3,8-10"
  #
  #   Bible::Verse.format_verse_numbers([1, 3, 5, 6])
  #   # => "1,3,5,6"
  #
  #   Bible::Verse.format_verse_numbers([1, 1])
  #   # => "1"
  def self.format_verse_numbers(numbers)
    chunks = numbers.chunk_while do |previous_number, next_number|
      next_number == previous_number + 1
    end

    chunks.map do |chunk|
      if chunk.size > 2
        "#{chunk.first}-#{chunk.last}"
      else
        chunk
      end
    end.flatten.uniq.join(",")
  end
end
