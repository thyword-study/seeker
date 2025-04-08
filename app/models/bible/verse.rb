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
  belongs_to :chapter
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
end
