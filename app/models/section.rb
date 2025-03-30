# ## Schema Information
#
# Table name: `sections`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `bigint`           | `not null, primary key`
# **`position`**    | `integer`          | `not null`
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
# **`bible_id`**    | `bigint`           | `not null`
# **`book_id`**     | `bigint`           | `not null`
# **`chapter_id`**  | `bigint`           | `not null`
# **`heading_id`**  | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_sections_on_bible_id`:
#     * **`bible_id`**
# * `index_sections_on_book_id`:
#     * **`book_id`**
# * `index_sections_on_chapter_id`:
#     * **`chapter_id`**
# * `index_sections_on_heading_id`:
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
class Section < ApplicationRecord
  # Associations
  belongs_to :bible
  belongs_to :book
  belongs_to :chapter
  belongs_to :heading
  has_many :section_segment_associations, dependent: :destroy
  has_many :segments, through: :section_segment_associations
  has_one :exposition_content, dependent: :restrict_with_error, class_name: "Exposition::Content"

  # Validations
  validates :bible, presence: true
  validates :book, presence: true
  validates :chapter, presence: true
  validates :heading, presence: true
  validates :position, presence: true, numericality: { only_integer: true, greater_than: 0 }

  # Determines if a section is ready for exposition.
  #
  # @return [Boolean] true if any segment's USX style is a content style, false
  # otherwise.
  def expositable?
    segments.where(usx_style: Segment::CONTENT_STYLES.map(&:to_s)).exists?
  end

  # Generates a structured user prompt for generating a commentary.
  #
  # This method constructs a text excerpt from the Berean Standard Bible (BSB),
  # along with associated footnotes, to serve as input for commentary
  # generation.
  #
  # The prompt includes:
  # - An instruction section guiding the use of the provided text.
  # - The passage text, ordered based on segments and fragments.
  # - The book, chapter, and verse reference.
  # - A footnotes section, if applicable, mapping footnotes to letters.
  #
  # @return [String] A formatted prompt containing the passage, reference, and footnotes.
  def user_prompt
    # Generate mapping of footnotes in the passage so as to generate a footnote
    # section after the passage.
    footnotes_mapping = {}
    footnotes = Footnote.where(bible: bible, book: book, chapter: chapter).order(created_at: :asc)
    footnotes.each.with_index(1) do |footnote, footnote_number|
      footnote_letter = Footnote.integer_to_letter(footnote_number)
      footnotes_mapping[footnote.id] = { letter: footnote_letter }
    end

    prompt = []
    prompt << <<~HEREDOC.strip
      <instructions>
      1. Generate a commentary and work exclusively with the following text excerpt from the Berean Standard Bible (BSB).
      2. When quoting or referring to the text, use the exact wording provided in the text excerpt.
      </instructions>
    HEREDOC

    # Stitch together the passage from the segments and child fragments into a
    # multi-line string.
    text = []
    verse_numbers = []
    segments.order(usx_position: :asc).each do |segment|
      segment.fragments.order(position: :asc).each do |fragment|
        case fragment.kind
        when "note"
          footnote_letter = footnotes_mapping[fragment.content.to_i][:letter]

          text << "[#{footnote_letter}]"
        when "reference"
          next
        else
          verse_numbers << fragment.verse.number if fragment.verse.present?
          text << "\n#{fragment.verse.number} " if fragment.verse.present? && fragment.show_verse
          text << fragment.content
        end
      end

      text << "\n"
    end
    verse_numbers.uniq!
    prompt << "\n\n"
    prompt << "<text>\n"
    prompt << "#{text.join("").strip}\n"
    prompt << "\n"
    prompt << "#{book.title} #{chapter.number}:#{verse_numbers.join(",")} #{bible.code}\n"
    prompt << "</text>"

    # Sometimes the passage has footnotes, and it's worth adding these to the
    # user prompt to provide extra context.
    if footnotes.any?
      prompt << "\n\n"
      prompt << "<footnotes>\n"
      footnotes.each do |footnote|
        prompt << "[#{footnotes_mapping[footnote.id][:letter]}]: #{footnote.content}\n"
      end
      prompt << "</footnotes>\n"
    end

    prompt.join("").strip
  end
end
