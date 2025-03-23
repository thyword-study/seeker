# ## Schema Information
#
# Table name: `segments`
#
# ### Columns
#
# Name               | Type               | Attributes
# ------------------ | ------------------ | ---------------------------
# **`id`**           | `bigint`           | `not null, primary key`
# **`usx_style`**    | `string`           | `not null`
# **`created_at`**   | `datetime`         | `not null`
# **`updated_at`**   | `datetime`         | `not null`
# **`bible_id`**     | `bigint`           | `not null`
# **`book_id`**      | `bigint`           | `not null`
# **`chapter_id`**   | `bigint`           | `not null`
# **`heading_id`**   | `bigint`           | `not null`
# **`usx_node_id`**  | `integer`          | `not null`
#
# ### Indexes
#
# * `index_segments_on_bible_id`:
#     * **`bible_id`**
# * `index_segments_on_book_id`:
#     * **`book_id`**
# * `index_segments_on_chapter_id`:
#     * **`chapter_id`**
# * `index_segments_on_heading_id`:
#     * **`heading_id`**
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
#
class Segment < ApplicationRecord
  # Associations
  belongs_to :bible
  belongs_to :book
  belongs_to :chapter
  belongs_to :heading
  has_many :fragments, dependent: :restrict_with_error
  has_many :segment_verse_associations, dependent: :destroy
  has_many :verses, through: :segment_verse_associations

  # Validations
  validates :bible, presence: true
  validates :book, presence: true
  validates :chapter, presence: true
  validates :heading, presence: true
  validates :usx_node_id, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :usx_style, presence: true

  # Constants
  HEADER_STYLES_INTRODUCTORY = [ "h", "toc2", "toc1", "mt1" ]
  HEADER_STYLES_SECTIONS_MAJOR = { ms: 0, ms1: 1, ms2: 2, ms3: 3, ms4: 4 }
  HEADER_STYLES_SECTIONS_MINOR = { s: 0, s1: 1, s2: 2, s3: 3, s4: 4 }
end
