# ## Schema Information
#
# Table name: `books`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `bigint`           | `not null, primary key`
# **`code`**        | `string(3)`        | `not null`
# **`number`**      | `integer`          | `not null`
# **`slug`**        | `string`           | `not null`
# **`testament`**   | `string`           | `not null`
# **`title`**       | `string`           | `not null`
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
# **`bible_id`**    | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_books_on_bible_id`:
#     * **`bible_id`**
# * `index_books_on_bible_id_and_code` (_unique_):
#     * **`bible_id`**
#     * **`code`**
#
# ### Foreign Keys
#
# * `fk_rails_...` (_ON DELETE => restrict_):
#     * **`bible_id => bibles.id`**
#
class Book < ApplicationRecord
  # Associations
  belongs_to :bible

  # Validations
  validates :bible, presence: true
  validates :code, presence: true, length: { is: 3 }, uniqueness: true
  validates :number, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :slug, presence: true
  validates :testament, presence: true, inclusion: { in: %w[OT NT] }
  validates :title, presence: true
end
