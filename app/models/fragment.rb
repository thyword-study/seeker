# ## Schema Information
#
# Table name: `fragments`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `bigint`           | `not null, primary key`
# **`content`**     | `text`             | `not null`
# **`kind`**        | `string`           | `not null`
# **`show_verse`**  | `boolean`          | `not null`
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
# **`bible_id`**    | `bigint`           | `not null`
# **`book_id`**     | `bigint`           | `not null`
# **`chapter_id`**  | `bigint`           | `not null`
# **`heading_id`**  | `bigint`           | `not null`
# **`segment_id`**  | `bigint`           | `not null`
# **`verse_id`**    | `bigint`           |
#
# ### Indexes
#
# * `index_fragments_on_bible_id`:
#     * **`bible_id`**
# * `index_fragments_on_book_id`:
#     * **`book_id`**
# * `index_fragments_on_chapter_id`:
#     * **`chapter_id`**
# * `index_fragments_on_heading_id`:
#     * **`heading_id`**
# * `index_fragments_on_segment_id`:
#     * **`segment_id`**
# * `index_fragments_on_verse_id`:
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
#     * **`heading_id => headings.id`**
# * `fk_rails_...` (_ON DELETE => restrict_):
#     * **`segment_id => segments.id`**
# * `fk_rails_...` (_ON DELETE => restrict_):
#     * **`verse_id => verses.id`**
#
class Fragment < ApplicationRecord
  # Associations
  belongs_to :bible
  belongs_to :book
  belongs_to :chapter
  belongs_to :heading
  belongs_to :segment
  belongs_to :verse, optional: true

  # Validations
  validates :bible, presence: true
  validates :book, presence: true
  validates :chapter, presence: true
  validates :content, presence: true
  validates :heading, presence: true
  validates :kind, presence: true
  validates :segment, presence: true
  validates :show_verse, inclusion: { in: [ true, false ] }

  # Enums
  enum :kind, { text: "text", note: "note", reference: "reference" }
end
