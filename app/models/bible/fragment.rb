# ## Schema Information
#
# Table name: `bible_fragments`
#
# ### Columns
#
# Name                     | Type               | Attributes
# ------------------------ | ------------------ | ---------------------------
# **`id`**                 | `bigint`           | `not null, primary key`
# **`content`**            | `text`             | `not null`
# **`fragmentable_type`**  | `string`           |
# **`kind`**               | `string`           | `not null`
# **`position`**           | `integer`          | `not null`
# **`show_verse`**         | `boolean`          | `not null`
# **`created_at`**         | `datetime`         | `not null`
# **`updated_at`**         | `datetime`         | `not null`
# **`book_id`**            | `bigint`           | `not null`
# **`chapter_id`**         | `bigint`           | `not null`
# **`fragmentable_id`**    | `bigint`           |
# **`heading_id`**         | `bigint`           | `not null`
# **`segment_id`**         | `bigint`           | `not null`
# **`translation_id`**     | `bigint`           | `not null`
# **`verse_id`**           | `bigint`           |
#
# ### Indexes
#
# * `index_bible_fragments_on_book_id`:
#     * **`book_id`**
# * `index_bible_fragments_on_chapter_id`:
#     * **`chapter_id`**
# * `index_bible_fragments_on_fragmentable`:
#     * **`fragmentable_type`**
#     * **`fragmentable_id`**
# * `index_bible_fragments_on_heading_id`:
#     * **`heading_id`**
# * `index_bible_fragments_on_segment_id`:
#     * **`segment_id`**
# * `index_bible_fragments_on_translation_id`:
#     * **`translation_id`**
# * `index_bible_fragments_on_verse_id`:
#     * **`verse_id`**
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
#     * **`segment_id => bible_segments.id`**
# * `fk_rails_...` (_ON DELETE => restrict_):
#     * **`translation_id => bible_translations.id`**
# * `fk_rails_...` (_ON DELETE => restrict_):
#     * **`verse_id => bible_verses.id`**
#
class Bible::Fragment < ApplicationRecord
  # Associations
  belongs_to :book
  belongs_to :chapter
  belongs_to :fragmentable, polymorphic: true, optional: true
  belongs_to :heading
  belongs_to :segment
  belongs_to :translation
  belongs_to :verse, optional: true

  # Validations
  validates :book, presence: true
  validates :chapter, presence: true
  validates :content, presence: true
  validates :heading, presence: true
  validates :kind, presence: true
  validates :position, presence: true
  validates :segment, presence: true
  validates :show_verse, inclusion: { in: [ true, false ] }
  validates :translation, presence: true

  # Enums
  enum :kind, { text: "text", note: "note", reference: "reference" }
end
