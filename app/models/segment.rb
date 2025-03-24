# ## Schema Information
#
# Table name: `segments`
#
# ### Columns
#
# Name                | Type               | Attributes
# ------------------- | ------------------ | ---------------------------
# **`id`**            | `bigint`           | `not null, primary key`
# **`usx_position`**  | `integer`          | `not null`
# **`usx_style`**     | `string`           | `not null`
# **`created_at`**    | `datetime`         | `not null`
# **`updated_at`**    | `datetime`         | `not null`
# **`bible_id`**      | `bigint`           | `not null`
# **`book_id`**       | `bigint`           | `not null`
# **`chapter_id`**    | `bigint`           | `not null`
# **`heading_id`**    | `bigint`           | `not null`
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
  has_many :section_segment_associations, dependent: :destroy
  has_many :sections, through: :section_segment_associations
  has_many :segment_verse_associations, dependent: :destroy
  has_many :verses, through: :segment_verse_associations

  # Validations
  validates :bible, presence: true
  validates :book, presence: true
  validates :chapter, presence: true
  validates :heading, presence: true
  validates :usx_position, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :usx_style, presence: true

  # Constants
  GROUPABLE_STYLES = [ :li1, :li2, :pc, :q1, :q2 ]
  HEADER_STYLES_INTRODUCTORY = [ "h", "toc2", "toc1", "mt1" ]
  HEADER_STYLES_SECTIONS_MAJOR = { ms: 0, ms1: 1, ms2: 2, ms3: 3, ms4: 4 }
  HEADER_STYLES_SECTIONS_MINOR = { s: 0, s1: 1, s2: 2, s3: 3, s4: 4 }

  # Groups a collection of segments into logically coherent sections for further
  # processing.
  #
  # This method takes an enumerable collection of Segment records and groups
  # them based on their USX styles. Only segments with content styles are
  # processed. Within this grouping, specific groupable styles are further
  # aggregated based on:
  #
  # - **List Styles:** Consecutive segments with `li1` and `li2` styles are
  #   grouped together, where `li2` follows `li1` indicating a sub-list.
  # - **Poetry Styles:** Segments with `q1` followed by `q2` are grouped
  #   together to maintain poetic structure.
  # - **Inscriptions:** Consecutive `pc` (centered paragraph) segments are
  #   grouped to keep related inscriptions together.
  #
  # @param segments [Enumerable<Segment>] a collection of Segment objects.
  #
  # @return [Array<Array<Segment>>] an array of arrays, where each inner array
  # represents a grouped section of segments.
  #
  # @example segments = Segment.where(bible: @bible, book: @book, chapter: @chapter) .where.not(usx_style: "b") .order(usx_position: :asc)
  #                     sectioned_segments = Segment.group_in_sections(segments)
  #
  def self.group_in_sections(segments)
    # Now process all segments that belong to the chatper to generate a
    # logically grouped structure that makes it easier for further processing.
    # Excluding the styles above, these are the contextual styles that hold the
    # actual content:
    #
    # * `li1` - List Entry - Level 1
    # * `li2` - List Entry - Level 2
    # * `m` - Paragraph - Margin - No First Line Indent
    # * `pc` - Paragraph - Centered (for Inscription)
    # * `pmo` - Paragraph - Embedded Text Opening
    # * `q1` - Poetry - Indent Level 1
    # * `q2` - Poetry - Indent Level 2
    # * `qa` - Poetry - Acrostic Heading/Marker
    # * `qr` - Poetry - Right Aligned
    segments.chunk_while do |previous_segment, next_segment|
      if GROUPABLE_STYLES.include? next_segment.usx_style.to_sym
        # If we have groupable styles following each other group them into the
        # same section.
        groupable = GROUPABLE_STYLES.include?(previous_segment.usx_style.to_sym) && GROUPABLE_STYLES.include?(next_segment.usx_style.to_sym)

        # For groupable styles such as list and poetry styles, if they are
        # following each other it makes sense to stylistically group them
        # following based on their levels.
        groupable_list = [ "li1", "li2" ].include?(previous_segment.usx_style) && next_segment.usx_style == "li2"
        groupable_poetry = [ "q1", "q2" ].include?(previous_segment.usx_style) && next_segment.usx_style == "q2"

        # It makes sense to keep inscriptions in the same section as they
        # contextually related.
        groupable_inscriptions = previous_segment.usx_style == "pc" && next_segment.usx_style == "pc"

        (groupable && groupable_list) || (groupable && groupable_poetry) || (groupable && groupable_inscriptions)
      else
        false
      end
    end
  end
end
