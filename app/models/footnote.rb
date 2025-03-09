# ## Schema Information
#
# Table name: `footnotes`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `bigint`           | `not null, primary key`
# **`content`**     | `text`             | `not null`
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
# **`bible_id`**    | `bigint`           | `not null`
# **`book_id`**     | `bigint`           | `not null`
# **`chapter_id`**  | `bigint`           | `not null`
# **`verse_id`**    | `bigint`           |
#
# ### Indexes
#
# * `index_footnotes_on_bible_id`:
#     * **`bible_id`**
# * `index_footnotes_on_book_id`:
#     * **`book_id`**
# * `index_footnotes_on_chapter_id`:
#     * **`chapter_id`**
# * `index_footnotes_on_verse_id`:
#     * **`verse_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...` (_ON DELETE => restrict_):
#     * **`bible_id => bibles.id`**
# * `fk_rails_...` (_ON DELETE => restrict_):
#     * **`book_id => books.id`**
# * `fk_rails_...` (_ON DELETE => restrict_):
#     * **`chapter_id => chapters.id`**
# * `fk_rails_...` (_ON DELETE => restrict_):
#     * **`verse_id => verses.id`**
#
class Footnote < ApplicationRecord
  # Associations
  belongs_to :bible
  belongs_to :book
  belongs_to :chapter
  belongs_to :verse, optional: true
  has_many :fragments, as: :fragmentable

  # Validations
  validates :bible, presence: true
  validates :book, presence: true
  validates :chapter, presence: true
  validates :content, presence: true
end
