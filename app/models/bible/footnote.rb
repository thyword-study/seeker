# ## Schema Information
#
# Table name: `bible_footnotes`
#
# ### Columns
#
# Name                  | Type               | Attributes
# --------------------- | ------------------ | ---------------------------
# **`id`**              | `bigint`           | `not null, primary key`
# **`content`**         | `text`             | `not null`
# **`created_at`**      | `datetime`         | `not null`
# **`updated_at`**      | `datetime`         | `not null`
# **`book_id`**         | `bigint`           | `not null`
# **`chapter_id`**      | `bigint`           | `not null`
# **`translation_id`**  | `bigint`           | `not null`
# **`verse_id`**        | `bigint`           |
#
# ### Indexes
#
# * `index_bible_footnotes_on_book_id`:
#     * **`book_id`**
# * `index_bible_footnotes_on_chapter_id`:
#     * **`chapter_id`**
# * `index_bible_footnotes_on_translation_id`:
#     * **`translation_id`**
# * `index_bible_footnotes_on_verse_id`:
#     * **`verse_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...` (_ON DELETE => restrict_):
#     * **`book_id => bible_books.id`**
# * `fk_rails_...` (_ON DELETE => restrict_):
#     * **`chapter_id => bible_chapters.id`**
# * `fk_rails_...` (_ON DELETE => restrict_):
#     * **`translation_id => bible_translations.id`**
# * `fk_rails_...` (_ON DELETE => restrict_):
#     * **`verse_id => bible_verses.id`**
#
class Bible::Footnote < ApplicationRecord
  # Associations
  belongs_to :book
  belongs_to :chapter
  belongs_to :translation
  belongs_to :verse, optional: true
  has_many :fragments, as: :fragmentable

  # Validations
  validates :book, presence: true
  validates :chapter, presence: true
  validates :content, presence: true
  validates :translation, presence: true

  # Converts an integer to its corresponding alphabetical representation,
  # following a sequential pattern where 1 → "a", 26 → "z", 27 → "aa", etc.
  #
  # This method is useful for generating footnote markers from verses, ensuring
  # that footnotes are labeled alphabetically in a consistent manner.
  #
  # @param n [Integer] The footnote index (1-based).
  # @return [String] The corresponding alphabetical letter.
  def self.integer_to_letter(number)
    letter = ""

    while number > 0
      number -= 1 # Shift index to make 'a' start at 1 instead of 0
      letter.prepend((97 + (number % 26)).chr)  # Convert remainder to a letter
      number /= 26
    end

    letter
  end
end
