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
# **`verse_spec`**      | `string`           |
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

  # Scopes
  scope :expositable, -> { where.not(verse_spec: nil) }

  # Determines if a section is ready for exposition.
  #
  # @return [Boolean] true if the section is expositable, false otherwise.
  def expositable?
    verse_spec.present?
  end

  # Generate the verse spec for the section based on the segments and their
  # associated verses.
  #
  # A verse spec is a formatted string representation of verse numbers for the
  # section. This method checks if any of the associated segments contain
  # verses. If so, it collects all the verse numbers, orders them, removes
  # duplicates, and formats them into a human-readable string.

  # @return [String, nil] A formatted string of verse numbers if verses exist, or nil otherwise.
  def generate_verse_spec
    if segments.any? { |segment| segment.verses.exists? }
      numbers = segments
                   .order(usx_position: :asc)
                   .flat_map { |segment| segment.verses.order(number: :asc).pluck(:number) }
                   .uniq
                   .sort
      Bible::Verse.format_verse_numbers(numbers)
    end
  end

  # Returns the formatted title of the Bible section.
  #
  # This method constructs the title using the book's title, the chapter number,
  # and the verse specification. The verse specification is a formatted string
  # representing the verse numbers associated with the section.
  #
  # @return [String, nil] The formatted title of the section in the format "Book
  #   Title Chapter:FormattedVerseNumbers", or nil if the verse specification is
  #   absent.
  def title
    return nil unless verse_spec

    "#{book.title} #{chapter.number}:#{verse_spec}"
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
  # with the generated data and updates it with the batch payload.
  #
  # @param [String] name The name of the batch request.
  # @param [ActiveRecord::Relation] sections The sections to process, ordered by position.
  # @param [Exposition::SystemPrompt] system_prompt The system prompt to associate with the user prompts.
  # @return [Exposition::BatchRequest] The created batch request record containing the request data.
  def self.create_batch_request(name, sections, system_prompt)
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
