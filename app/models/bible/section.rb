# ## Schema Information
#
# Table name: `bible_sections`
#
# ### Columns
#
# Name                  | Type               | Attributes
# --------------------- | ------------------ | ---------------------------
# **`id`**              | `bigint`           | `not null, primary key`
# **`position`**        | `integer`          | `not null`
# **`created_at`**      | `datetime`         | `not null`
# **`updated_at`**      | `datetime`         | `not null`
# **`book_id`**         | `bigint`           | `not null`
# **`chapter_id`**      | `bigint`           | `not null`
# **`heading_id`**      | `bigint`           | `not null`
# **`translation_id`**  | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_bible_sections_on_book_id`:
#     * **`book_id`**
# * `index_bible_sections_on_chapter_id`:
#     * **`chapter_id`**
# * `index_bible_sections_on_heading_id`:
#     * **`heading_id`**
# * `index_bible_sections_on_translation_id`:
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
class Bible::Section < ApplicationRecord
  # Associations
  belongs_to :book
  belongs_to :chapter
  belongs_to :heading
  belongs_to :translation
  has_many :section_segment_associations, dependent: :destroy
  has_many :segments, through: :section_segment_associations
  has_many :exposition_user_prompts, dependent: :restrict_with_error, class_name: "Exposition::UserPrompt"
  has_one :exposition_content, dependent: :restrict_with_error, class_name: "Exposition::Content"

  # Validations
  validates :book, presence: true
  validates :chapter, presence: true
  validates :heading, presence: true
  validates :position, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :translation, presence: true

  # Determines if a section is ready for exposition.
  #
  # @return [Boolean] true if any segment's USX style is a content style, false
  # otherwise.
  def expositable?
    segments.where(usx_style: Bible::Segment::CONTENT_STYLES.map(&:to_s)).exists?
  end

  # Returns the formatted title of the Bible section.
  #
  # The title is constructed using the book title, chapter number, and a formatted
  # list of verse numbers.
  #
  # @return [String] the formatted title of the section in the format
  #   "Book Title Chapter:FormattedVerseNumbers".
  def title
    unformatted_verse_numbers = segments.order(usx_position: :asc).map do |segment|
      segment.verses.order(number: :asc).map do |verse|
        verse.number
      end
    end.flatten.uniq.sort!

    return "#{book.title} #{chapter.number}" if unformatted_verse_numbers.empty?

    formatted_verse_numbers = Bible::Verse.format_verse_numbers unformatted_verse_numbers
    "#{book.title} #{chapter.number}:#{formatted_verse_numbers}"
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
    footnotes = Bible::Footnote.where(translation: translation, book: book, chapter: chapter).order(created_at: :asc)
    footnotes.each.with_index(1) do |footnote, footnote_number|
      footnote_letter = Bible::Footnote.integer_to_letter(footnote_number)
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
    prompt << "#{book.title} #{chapter.number}:#{verse_numbers.join(",")} #{translation.code}\n"
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

  # Prepares and submits a batch of section data for processing by the
  # ExpositionService.
  #
  # This method processes the provided sections, filtering them to include only
  # those that are expositable. For each valid section, it generates a user
  # prompt and constructs an HTTP request payload formatted for batch processing
  # by the ExpositionService. The method then creates a batch request record
  # with the generated data.
  #
  # @param [String] name The name of the batch request.
  # @param [ActiveRecord::Relation] sections The sections to process, ordered by position.
  # @param [Exposition::SystemPrompt] system_prompt The system prompt to associate with the user prompts.
  # @return [Exposition::BatchRequest] The created batch request record containing the request data.
  def self.batch_request(name, sections, system_prompt)
    ActiveRecord::Base.transaction do
      batch_request = Exposition::BatchRequest.create!(
        name: name,
        status: "requested"
      )

      batch_data = sections.order(position: :asc).find_each(batch_size: 100).filter_map do |section|
        next unless section.expositable?

        user_prompt = system_prompt.user_prompts.create!(batch_request: batch_request, section: section, text: section.user_prompt)

        {
          custom_id: user_prompt.id.to_s,
          method: "POST",
          url: ExpositionService::ENDPOINT_RESPONSES,
          body: {
            input: user_prompt.text,
            instructions: system_prompt.text,
            max_output_tokens: ExpositionService::MAX_OUTPUT_TOKENS,
            model: ExpositionService::MODEL,
            text: { format: JSON.parse(Exposition::STRUCTURED_OUTPUT_JSON_SCHEMA) },
            stream: false,
            store: false,
            temperature: ExpositionService::TEMPERATURE,
            top_p: ExpositionService::TOP_P
          }
        }
      end

      batch_request.update! data: batch_data
      batch_request
    end
  end
end
