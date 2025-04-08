# ## Schema Information
#
# Table name: `bible_segments`
#
# ### Columns
#
# Name                  | Type               | Attributes
# --------------------- | ------------------ | ---------------------------
# **`id`**              | `bigint`           | `not null, primary key`
# **`usx_position`**    | `integer`          | `not null`
# **`usx_style`**       | `string`           | `not null`
# **`created_at`**      | `datetime`         | `not null`
# **`updated_at`**      | `datetime`         | `not null`
# **`book_id`**         | `bigint`           | `not null`
# **`chapter_id`**      | `bigint`           | `not null`
# **`heading_id`**      | `bigint`           | `not null`
# **`translation_id`**  | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_bible_segments_on_book_id`:
#     * **`book_id`**
# * `index_bible_segments_on_chapter_id`:
#     * **`chapter_id`**
# * `index_bible_segments_on_heading_id`:
#     * **`heading_id`**
# * `index_bible_segments_on_translation_id`:
#     * **`translation_id`**
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
#     * **`translation_id => bible_translations.id`**
#
class Bible::Segment < ApplicationRecord
  # Associations
  belongs_to :book
  belongs_to :chapter
  belongs_to :heading
  belongs_to :translation
  has_many :fragments, dependent: :restrict_with_error
  has_many :section_segment_associations, dependent: :destroy
  has_many :sections, through: :section_segment_associations
  has_many :segment_verse_associations, dependent: :destroy
  has_many :verses, through: :segment_verse_associations

  # Validations
  validates :book, presence: true
  validates :chapter, presence: true
  validates :heading, presence: true
  validates :translation, presence: true
  validates :usx_position, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :usx_style, presence: true

  # Constants
  CONTENT_STYLES = [ :d, :li1, :li2, :m, :pc, :pmo, :q1, :q2, :qr ]
  GROUPABLE_STYLES = [ :li1, :li2, :m, :pc, :pmo, :q1, :q2, :qr ]
  HEADER_STYLES_INTRODUCTORY = [ "h", "toc2", "toc1", "mt1" ]
  HEADER_STYLES_SECTIONS_MAJOR = { ms: 0, ms1: 1, ms2: 2, ms3: 3, ms4: 4 }
  HEADER_STYLES_SECTIONS_MINOR = { s: 0, s1: 1, s2: 2, s3: 3, s4: 4 }

  # Groups a collection of segments into logically coherent sections for
  # structured processing.
  #
  # This method takes an enumerable collection of `Segment` records and
  # organizes them based on their USX styles. Only segments with recognized
  # content styles are processed. Within this grouping, specific styles are
  # further aggregated to maintain logical continuity:
  #
  # - **List Styles (`li1`, `li2`)**: Consecutive segments are grouped together,
  #   where `li2` follows `li1` to indicate a sub-list.
  # - **Poetry Styles (`q1`, `q2`, `qr`)**: Segments are grouped to preserve
  #   poetic structure.
  # - **Inscriptions (`pc`)**: Consecutive `pc` segments are grouped to retain
  #   structured inscriptions.
  # - **Verse Continuity**: Segments belonging to the same verse are grouped
  #   together for contextual consistency.
  #
  # @param segments [Enumerable<Segment>] A collection of `Segment` objects,
  #   typically pre-filtered and ordered by `usx_position`.
  #
  # @return [Array<Array<Segment>>] An array of grouped segment arrays, where
  #   each inner array represents a cohesive section of related segments.
  #
  # @example
  #   segments = Segment.where(bible: @bible, book: @book, chapter: @chapter)
  #                     .where.not(usx_style: "b")
  #                     .order(usx_position: :asc)
  #   sectioned_segments = Segment.group_in_sections(segments)
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
      if GROUPABLE_STYLES.include?(previous_segment.usx_style.to_sym) && GROUPABLE_STYLES.include?(next_segment.usx_style.to_sym)
        # For groupable styles such as list and poetry styles, if they are
        # following each other it makes sense to stylistically group them
        # following based on their levels.
        groupable_list = [ "li1", "li2" ].include?(previous_segment.usx_style) && next_segment.usx_style == "li2"
        groupable_poetry = [ "q1", "q2" ].include?(previous_segment.usx_style) && [ "q2", "qr" ].include?(next_segment.usx_style)

        # For segments within the same verse, group them together because it
        # just makes sense to.
        groupable_verses = previous_segment.verses.ids == next_segment.verses.ids

        # If we have groupable styles following each other group them into the
        # same section.
        groupable_list || groupable_poetry || groupable_verses
      else
        false
      end
    end
  end
end
