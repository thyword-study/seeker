# ## Schema Information
#
# Table name: `bible_references`
#
# ### Columns
#
# Name                  | Type               | Attributes
# --------------------- | ------------------ | ---------------------------
# **`id`**              | `bigint`           | `not null, primary key`
# **`target`**          | `string`           | `not null`
# **`created_at`**      | `datetime`         | `not null`
# **`updated_at`**      | `datetime`         | `not null`
# **`book_id`**         | `bigint`           | `not null`
# **`chapter_id`**      | `bigint`           | `not null`
# **`heading_id`**      | `bigint`           |
# **`translation_id`**  | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_bible_references_on_book_id`:
#     * **`book_id`**
# * `index_bible_references_on_chapter_id`:
#     * **`chapter_id`**
# * `index_bible_references_on_heading_id`:
#     * **`heading_id`**
# * `index_bible_references_on_translation_id`:
#     * **`translation_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...` (_ON DELETE => restrict_):
#     * **`book_id => bible_books.id`**
# * `fk_rails_...` (_ON DELETE => restrict_):
#     * **`chapter_id => bible_chapters.id`**
# * `fk_rails_...` (_ON DELETE => restrict_):
#     * **`heading_id => bible_headings.id`**
# * `fk_rails_...` (_ON DELETE => restrict_):
#     * **`translation_id => bible_translations.id`**
#
class Bible::Reference < ApplicationRecord
  # Associations
  belongs_to :book
  belongs_to :chapter
  belongs_to :heading, optional: true
  belongs_to :translation
  has_many :fragments, as: :fragmentable

  # Validations
  validates :book, presence: true
  validates :chapter, presence: true
  validates :target, presence: true
  validates :translation, presence: true
end
