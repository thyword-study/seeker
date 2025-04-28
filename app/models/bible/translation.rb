# ## Schema Information
#
# Table name: `bible_translations`
#
# ### Columns
#
# Name                      | Type               | Attributes
# ------------------------- | ------------------ | ---------------------------
# **`id`**                  | `bigint`           | `not null, primary key`
# **`books_count`**         | `integer`          | `default(0), not null`
# **`code`**                | `string(3)`        | `not null`
# **`name`**                | `string`           | `not null`
# **`rights_holder_name`**  | `string`           | `not null`
# **`rights_holder_url`**   | `string`           | `not null`
# **`statement`**           | `text`             | `not null`
# **`created_at`**          | `datetime`         | `not null`
# **`updated_at`**          | `datetime`         | `not null`
#
# ### Indexes
#
# * `index_bible_translations_on_code` (_unique_):
#     * **`code`**
#
class Bible::Translation < ApplicationRecord
  # Associations
  has_many :books, dependent: :restrict_with_error
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
  validates :name, presence: true
  validates :rights_holder_name, presence: true
  validates :rights_holder_url, presence: true, url: true
  validates :statement, presence: true

  # Parses a Bible reference string into its components.
  #
  # The format of the reference can either be for a chapter in the format "BOOK
  # CHAPTER" (e.g., "JHN 3") or for verses in the format "BOOK CHAPTER:VERSES"
  # (e.g., "JHN 3:16-18").
  #
  # @param reference [String] The Bible reference for a chapter or verse.
  #
  # @return [Hash, nil] A hash with keys :book, :chapter, and :verses if parsing succeeds, otherwise nil.
  #
  # @example
  #   Bible::Translation.parse_reference("ROM 5:12,15-17")
  #   #=> { book: "ROM", chapter: 5, verses: [12, [15, 17]] }
  def self.parse_reference(reference)
    match = reference.match(/(?<book>\w{3}) (?<chapter>\d+)(:(?<verses>[\d\-:,]+))?/)
    return nil unless match

    book = match[:book]
    chapter = match[:chapter].to_i
    verses = match[:verses]

    unless verses.nil?
      verses = match[:verses].split(",").map do |range|
        range.include?("-") ? range.split("-").map(&:to_i) : range.to_i
      end
    end

    { book: book, chapter: chapter, verses: verses }
  end
end
