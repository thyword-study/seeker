# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Configure logging for debugging
previous_logger = nil
if ENV["DEBUG"]
  previous_logger = Rails.logger
  Rails.logger = Logger.new(STDOUT)
end

# Read bible metadata
bible_folder = File.join(Rails.root, "db", "data", "bibles", "BSB")
metadata_file_path = File.join(bible_folder, "metadata.xml")
metadata_file = File.read(metadata_file_path)
metadata_content = Nokogiri::XML(metadata_file)

# Extract bible data
bible_abbreviation = metadata_content.at_xpath("/DBLMetadata/identification/abbreviation").content
bible_name = metadata_content.at_xpath("/DBLMetadata/identification/name").content
bible_statement = metadata_content.at_xpath("/DBLMetadata/copyright/fullStatement/statementContent/p").content
bible_rights_holder_name = metadata_content.at_xpath("/DBLMetadata/agencies/rightsHolder/name").content
bible_rights_holder_url = metadata_content.at_xpath("/DBLMetadata/agencies/rightsHolder/url").content

# Save bible data into database
translation = Bible::Translation.create!(name: bible_name, code: bible_abbreviation, statement: bible_statement, rights_holder_name: bible_rights_holder_name, rights_holder_url: bible_rights_holder_url)
puts "Seeded Bible: [#{translation.code}] #{translation.name}"

# Read books' metadata and contents
metadata_content.xpath("/DBLMetadata/publications/publication/structure/content").each.with_index(1) do |book_info, book_number|
  # Extract bible data
  book_code = book_info["role"]
  book_name = book_info["name"]
  book_title = metadata_content.at_xpath("/DBLMetadata/names/name[@id=\"#{book_name}\"]/long").content
  book_slug = book_title.parameterize
  book_testament = "OT" if Bible::Book::NUMBERS_OT.include? book_number
  book_testament = "NT" if Bible::Book::NUMBERS_NT.include? book_number

  # Save book data into database
  book = Bible::Book.create!(translation: translation, title: book_title, number: book_number, code: book_code, slug: book_slug, testament: book_testament)
  puts "Seeded Bible Book ##{book.number}: [#{book.code}] #{book.title}"

  # Read book contents
  book_relative_file_path = book_info["src"]
  book_file_path = File.join(bible_folder, book_relative_file_path)
  book_file = File.read(book_file_path)
  book_content = Nokogiri::XML(book_file)

  # Extract bible data
  chapter = nil
  heading = nil
  verse = nil
  book_content.root.children.each.with_index(1) do |segment_node, segment_position|
    next if Rails.env.test? && segment_position > 50

    show_verse = false

    case segment_node.node_name
    when "chapter"
      if segment_node.key?("sid")
        chapter_number = segment_node["number"].to_i
        chapter = Bible::Chapter.create!(translation: translation, book: book, number: chapter_number)
        Rails.logger.info "Seeded Bible Book ##{book.number}: [#{book.code}] #{book.title} Chapter ##{chapter.number}"
      elsif segment_node.key?("eid")
        chapter = nil
      end
    when "para"
      segment_style = segment_node["style"]

      next if Bible::Segment::HEADER_STYLES_INTRODUCTORY.include? segment_style

      if Bible::Segment::HEADER_STYLES_SECTIONS_MAJOR.key?(segment_style.to_sym) || Bible::Segment::HEADER_STYLES_SECTIONS_MINOR.key?(segment_style.to_sym)
        if Bible::Segment::HEADER_STYLES_SECTIONS_MAJOR.key? segment_style.to_sym
          heading_kind = 'major'
          heading_level = Bible::Segment::HEADER_STYLES_SECTIONS_MAJOR[segment_style.to_sym]
        elsif Bible::Segment::HEADER_STYLES_SECTIONS_MINOR.key? segment_style.to_sym
          heading_kind = 'minor'
          heading_level = Bible::Segment::HEADER_STYLES_SECTIONS_MINOR[segment_style.to_sym]
        end

        heading = Bible::Heading.create!(translation: translation, book: book, chapter: chapter, kind: heading_kind, level: heading_level, title: segment_node.text)
        Rails.logger.info "Seeded Bible Book ##{book.number}: [#{book.code}] #{book.title} Chapter ##{chapter.number} Heading #{heading.level} (#{heading.title})"
      end

      segment = Bible::Segment.create!(translation: translation, book: book, chapter: chapter, heading: heading, usx_position: segment_position, usx_style: segment_style)
      Rails.logger.info "Seeded Bible Book ##{book.number}: [#{book.code}] #{book.title} Chapter ##{chapter&.number} Segment #{segment.id}"

      segment_node.children.each.with_index(1) do |fragment_node, fragment_position|
        fragment_text = fragment_node.text.strip
        fragment_kind = nil
        fragmentable = nil

        case fragment_node.node_type
        when Nokogiri::XML::Node::ELEMENT_NODE
          case fragment_node.node_name
          when "char"
            fragment_kind = "text"
          when "ref"
            fragment_kind = "reference"
            reference_target = fragment_node["loc"]
            reference = Bible::Reference.create!(translation: translation, book: book, chapter: chapter, heading: heading, target: reference_target)
            fragmentable = reference
            Rails.logger.info "Seeded Bible Book ##{book.number}: [#{book.code}] #{book.title} Chapter ##{chapter.number} Reference #{reference.id}"
          when "note"
            fragment_kind = "note"
            footnote_text = fragment_node.children.select { |note_child_node| note_child_node.node_name == "char" && note_child_node["style"] == "ft" }.first.text.strip
            footnote = Bible::Footnote.create!(translation: translation, book: book, chapter: chapter, verse: verse, content: footnote_text)
            fragmentable = footnote
            fragment_text = "#{footnote.id}"
            Rails.logger.info "Seeded Bible Book ##{book.number}: [#{book.code}] #{book.title} Chapter ##{chapter.number} Verse #{verse&.number} Footnote #{footnote.id}"
          when "verse"
            if fragment_node.key?("sid")
              show_verse = true
              verse_number = fragment_node["number"].to_i
              verse = Bible::Verse.create!(translation: translation, book: book, chapter: chapter, number: verse_number)
              Rails.logger.info "Seeded Bible Book ##{book.number}: [#{book.code}] #{book.title} Chapter ##{chapter.number} Verse #{verse&.number}"
            elsif fragment_node.key?("eid")
              verse = nil
            end
          else
            Rails.logger.fatal "Unsupported node_type: #{fragment_node.node_name} (#{fragment_text})"
          end
        when Nokogiri::XML::Node::TEXT_NODE
          fragment_kind = "text"
        end

        next if fragment_text.empty?

        fragment = Bible::Fragment.create!(translation: translation, book: book, segment: segment, chapter: chapter, heading: heading, verse: verse, kind: fragment_kind, show_verse: show_verse, content: fragment_text, position: fragment_position, fragmentable: fragmentable)
        segment.verses << fragment.verse if fragment.verse.present? && segment.verses.exclude?(fragment.verse)
        show_verse = false if fragment.show_verse
        Rails.logger.info "Seeded Bible Book ##{book.number}: [#{book.code}] #{book.title} Chapter ##{chapter&.number} Segment #{segment.id} Fragment #{fragment.id} (#{fragment.content})"
      end
    end
  end

  # Chunk the segments into sections
  chapters = Bible::Chapter.where(translation: translation, book: book).order(number: :asc)
  chapters.each { |chapter| chapter.group_segments_in_sections!(regroup: false) }
end

# Reset counters for Bible translations, books, chapters, and verses.
ResetBibleCountersJob.perform_now

# Restore previous logger
Rails.logger = previous_logger if ENV["DEBUG"]
