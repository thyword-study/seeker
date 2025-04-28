# ## Schema Information
#
# Table name: `bible_books`
#
# ### Columns
#
# Name                  | Type               | Attributes
# --------------------- | ------------------ | ---------------------------
# **`id`**              | `bigint`           | `not null, primary key`
# **`chapters_count`**  | `integer`          | `default(0), not null`
# **`code`**            | `string(3)`        | `not null`
# **`number`**          | `integer`          | `not null`
# **`slug`**            | `string`           | `not null`
# **`testament`**       | `string`           | `not null`
# **`title`**           | `string`           | `not null`
# **`created_at`**      | `datetime`         | `not null`
# **`updated_at`**      | `datetime`         | `not null`
# **`translation_id`**  | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_bible_books_on_translation_id`:
#     * **`translation_id`**
# * `index_bible_books_on_translation_id_and_code` (_unique_):
#     * **`translation_id`**
#     * **`code`**
#
# ### Foreign Keys
#
# * `fk_rails_...` (_ON DELETE => restrict_):
#     * **`translation_id => bible_translations.id`**
#
class Bible::Book < ApplicationRecord
  # Associations
  belongs_to :translation, counter_cache: true
  has_many :chapters, dependent: :restrict_with_error
  has_many :footnotes, dependent: :restrict_with_error
  has_many :fragments, dependent: :restrict_with_error
  has_many :headings, dependent: :restrict_with_error
  has_many :references, dependent: :restrict_with_error
  has_many :sections, dependent: :restrict_with_error
  has_many :segments, dependent: :restrict_with_error
  has_many :verses, dependent: :restrict_with_error

  # Validations
  validates :code, presence: true, length: { is: 3 }, uniqueness: true
  validates :number, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :slug, presence: true
  validates :testament, presence: true, inclusion: { in: %w[OT NT] }
  validates :title, presence: true
  validates :translation, presence: true

  # Constants
  NUMBERS_OT = (1..39)
  NUMBERS_NT = (40..66)

  # Scopes
  scope :old_testament, -> { where(testament: "OT") }
  scope :new_testament, -> { where(testament: "NT") }

  # Returns the number of the next book in the translation, or `nil` if the
  # current book is the last one in the translation.
  #
  # @return [Integer, nil] The number of the next book, or `nil` if there is no
  #   next book.
  def next_number
    if number == translation.books_count
      nil
    else
      number + 1
    end
  end

end
