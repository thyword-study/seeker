# ## Schema Information
#
# Table name: `verses`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `bigint`           | `not null, primary key`
# **`number`**      | `integer`          | `not null`
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
# **`bible_id`**    | `bigint`           | `not null`
# **`book_id`**     | `bigint`           | `not null`
# **`chapter_id`**  | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_verses_on_bible_id`:
#     * **`bible_id`**
# * `index_verses_on_bible_id_and_book_id_and_chapter_id_and_number` (_unique_):
#     * **`bible_id`**
#     * **`book_id`**
#     * **`chapter_id`**
#     * **`number`**
# * `index_verses_on_book_id`:
#     * **`book_id`**
# * `index_verses_on_chapter_id`:
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
class Verse < ApplicationRecord
  # Associations
  belongs_to :bible
  belongs_to :book
  belongs_to :chapter
  has_many :fragments, dependent: :restrict_with_exception

  # Validations
  validates :bible, presence: true
  validates :book, presence: true
  validates :chapter, presence: true
  validates :number, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
