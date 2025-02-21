# ## Schema Information
#
# Table name: `bibles`
#
# ### Columns
#
# Name                      | Type               | Attributes
# ------------------------- | ------------------ | ---------------------------
# **`id`**                  | `bigint`           | `not null, primary key`
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
# * `index_bibles_on_code` (_unique_):
#     * **`code`**
#
class Bible < ApplicationRecord
  # Associations
  has_many :books, dependent: :restrict_with_exception
  has_many :chapters, dependent: :restrict_with_exception
  has_many :footnotes, dependent: :restrict_with_exception
  has_many :fragments, dependent: :restrict_with_exception
  has_many :headings, dependent: :restrict_with_exception
  has_many :references, dependent: :restrict_with_exception
  has_many :segments, dependent: :restrict_with_exception
  has_many :verses, dependent: :restrict_with_exception

  # Validations
  validates :code, presence: true, length: { is: 3 }, uniqueness: true
  validates :name, presence: true
  validates :rights_holder_name, presence: true
  validates :rights_holder_url, presence: true, url: true
  validates :statement, presence: true

  # Parses a Bible reference string into its components.
  #
  # @param reference [String] The Bible reference in the format "BOOK CHAPTER:VERSES" (e.g., "JHN 3:16-18").
  #
  # @return [Hash, nil] A hash with keys :book, :chapter, and :verses if parsing succeeds, otherwise nil.
  #
  # @example
  #   Bible.parse_reference("ROM 5:12,15-17")
  #   #=> { book: "ROM", chapter: 5, verses: [12, [15, 17]] }
  def self.parse_reference(reference)
    match = reference.match(/(?<book>\w{3}) (?<chapter>\d+):(?<verses>[\d\-:,]+)/)
    return nil unless match

    book = match[:book]
    chapter = match[:chapter].to_i
    verses = match[:verses].split(",").map do |range|
      range.include?("-") ? range.split("-").map(&:to_i) : range.to_i
    end

    { book: book, chapter: chapter, verses: verses }
  end
end
