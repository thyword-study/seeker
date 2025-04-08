# ## Schema Information
#
# Table name: `bible_headings`
#
# ### Columns
#
# Name                  | Type               | Attributes
# --------------------- | ------------------ | ---------------------------
# **`id`**              | `bigint`           | `not null, primary key`
# **`kind`**            | `string`           | `not null`
# **`level`**           | `integer`          | `not null`
# **`title`**           | `string`           | `not null`
# **`created_at`**      | `datetime`         | `not null`
# **`updated_at`**      | `datetime`         | `not null`
# **`book_id`**         | `bigint`           | `not null`
# **`chapter_id`**      | `bigint`           | `not null`
# **`translation_id`**  | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_bible_headings_on_book_id`:
#     * **`book_id`**
# * `index_bible_headings_on_chapter_id`:
#     * **`chapter_id`**
# * `index_bible_headings_on_translation_id`:
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
class Bible::Heading < ApplicationRecord
  # Associations
  belongs_to :book
  belongs_to :chapter
  belongs_to :translation
  has_many :fragments, dependent: :restrict_with_error
  has_many :references, dependent: :restrict_with_error
  has_many :sections, dependent: :restrict_with_error
  has_many :segments, dependent: :restrict_with_error

  # Validations
  validates :book, presence: true
  validates :chapter, presence: true
  validates :kind, presence: true
  validates :level, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :title, presence: true
  validates :translation, presence: true

  # Enums
  enum :kind, { major: "major", minor: "minor" }
end
