# ## Schema Information
#
# Table name: `headings`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `bigint`           | `not null, primary key`
# **`level`**       | `integer`          | `not null`
# **`title`**       | `string`           | `not null`
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
# **`bible_id`**    | `bigint`           | `not null`
# **`book_id`**     | `bigint`           | `not null`
# **`chapter_id`**  | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_headings_on_bible_id`:
#     * **`bible_id`**
# * `index_headings_on_book_id`:
#     * **`book_id`**
# * `index_headings_on_chapter_id`:
#     * **`chapter_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...` (_ON DELETE => restrict_):
#     * **`bible_id => bibles.id`**
# * `fk_rails_...` (_ON DELETE => restrict_):
#     * **`book_id => books.id`**
# * `fk_rails_...` (_ON DELETE => restrict_):
#     * **`chapter_id => chapters.id`**
#
class Heading < ApplicationRecord
  # Associations
  belongs_to :bible
  belongs_to :book
  belongs_to :chapter
  has_many :fragments, dependent: :restrict_with_error
  has_many :references, dependent: :restrict_with_error
  has_many :segments, dependent: :restrict_with_error

  # Validations
  validates :bible, presence: true
  validates :book, presence: true
  validates :chapter, presence: true
  validates :level, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :title, presence: true
end
