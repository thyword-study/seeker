require 'rails_helper'

RSpec.describe Bible::Section, type: :model do
  let(:translation) { FactoryBot.create(:translation_bsb) }
  let(:book) { FactoryBot.create(:translation_book, translation: translation, title: "Genesis") }
  let(:chapter) { FactoryBot.create(:translation_chapter, translation: translation, book: book, number: 1) }
  let(:heading) { FactoryBot.create(:translation_heading, translation: translation, book: book, chapter: chapter) }

  describe "#expositable?" do
    context "when there is a verse_spec" do
      it "returns true" do
        section = FactoryBot.create(:translation_section, translation: translation, book: book, chapter: chapter, heading: heading, position: 1, verse_spec: "1")

        expect(section.expositable?).to be true
      end
    end

    context "when there is no verse_spec" do
      it "returns false" do
        section = FactoryBot.create(:translation_section, translation: translation, book: book, chapter: chapter, heading: heading, position: 1)

        expect(section.expositable?).to be false
      end
    end
  end

  describe "#generate_verse_spec" do
    context "when the section has a single verse" do
      it "returns the correct verse_spec with the verse number" do
        section = FactoryBot.create(:translation_section, translation: translation, book: book, chapter: chapter, heading: heading, position: 1)
        segment = FactoryBot.create(:translation_segment, translation: translation, book: book, chapter: chapter, heading: heading)
        verse = FactoryBot.create(:translation_verse, translation: translation, book: book, chapter: chapter, number: 1)
        FactoryBot.create(:translation_fragment, translation: translation, book: book, chapter: chapter, heading: heading, segment: segment, verse: verse, position: 1)
        section.segments << segment
        segment.verses << verse

        expect(section.generate_verse_spec).to eq "1"
      end
    end

    context "when the section has multiple consecutive verses" do
      it "returns the correct verse_spec with a range of verse numbers" do
        section = FactoryBot.create(:translation_section, translation: translation, book: book, chapter: chapter, heading: heading, position: 1)
        segment = FactoryBot.create(:translation_segment, translation: translation, book: book, chapter: chapter, heading: heading)
        verse_1 = FactoryBot.create(:translation_verse, translation: translation, book: book, chapter: chapter, number: 1)
        verse_2 = FactoryBot.create(:translation_verse, translation: translation, book: book, chapter: chapter, number: 2)
        FactoryBot.create(:translation_fragment, translation: translation, book: book, chapter: chapter, heading: heading, segment: segment, verse: verse_1, position: 1)
        FactoryBot.create(:translation_fragment, translation: translation, book: book, chapter: chapter, heading: heading, segment: segment, verse: verse_2, position: 2)
        section.segments << segment
        segment.verses << verse_1
        segment.verses << verse_2

        expect(section.generate_verse_spec).to eq "1,2"
      end
    end

    context "when the section has non-consecutive verses" do
      it "returns the correct verse_spec with comma-separated verse numbers" do
        section = FactoryBot.create(:translation_section, translation: translation, book: book, chapter: chapter, heading: heading, position: 1)
        segment = FactoryBot.create(:translation_segment, translation: translation, book: book, chapter: chapter, heading: heading)
        verse_1 = FactoryBot.create(:translation_verse, translation: translation, book: book, chapter: chapter, number: 1)
        verse_2 = FactoryBot.create(:translation_verse, translation: translation, book: book, chapter: chapter, number: 2)
        verse_3 = FactoryBot.create(:translation_verse, translation: translation, book: book, chapter: chapter, number: 3)
        FactoryBot.create(:translation_fragment, translation: translation, book: book, chapter: chapter, heading: heading, segment: segment, verse: verse_1, position: 1)
        FactoryBot.create(:translation_fragment, translation: translation, book: book, chapter: chapter, heading: heading, segment: segment, verse: verse_2, position: 2)
        FactoryBot.create(:translation_fragment, translation: translation, book: book, chapter: chapter, heading: heading, segment: segment, verse: verse_3, position: 3)
        section.segments << segment
        segment.verses << verse_1
        segment.verses << verse_2
        segment.verses << verse_3

        expect(section.generate_verse_spec).to eq "1-3"
      end
    end

    context "when the section has no verses" do
      it "returns nil" do
        section = FactoryBot.create(:translation_section, translation: translation, book: book, chapter: chapter, heading: heading, position: 1)
        segment = FactoryBot.create(:translation_segment, translation: translation, book: book, chapter: chapter, heading: heading)
        FactoryBot.create(:translation_fragment, translation: translation, book: book, chapter: chapter, heading: heading, segment: segment, content: "In the beginning God created the heavens and the earth.", position: 1, verse: nil)
        section.segments << segment

        expect(section.generate_verse_spec).to be_nil
      end
    end
  end

  describe "#title" do
    context "when the section has a verse_spec" do
      it "returns the correct title with the verse number" do
        section = FactoryBot.create(:translation_section, translation: translation, book: book, chapter: chapter, heading: heading, position: 1, verse_spec: "1")

        expect(section.title).to eq "Genesis 1:1"
      end
    end

    context "when the section has no verse_spec" do
      it "returns the book and chapter without verse numbers" do
        section = FactoryBot.create(:translation_section, translation: translation, book: book, chapter: chapter, heading: heading, position: 1)

        expect(section.title).to be_nil
      end
    end
  end

  describe '#user_prompt' do
    let(:translation) { FactoryBot.create(:translation_bsb) }
    let(:book) { FactoryBot.create(:translation_book, translation: translation, title: "Genesis") }

    context "when the section has a single verse with simple fragments" do
      it 'returns the right user prompt' do
        section = FactoryBot.create(:translation_section, translation: translation, book: book, chapter: chapter, heading: heading, position: 1)
        segment = FactoryBot.create(:translation_segment, translation: translation, book: book, chapter: chapter, heading: heading, usx_position: 6, usx_style: 'm')
        verse = FactoryBot.create(:translation_verse, translation: translation, book: book, chapter: chapter, number: 1)
        fragment = FactoryBot.create(:translation_fragment, translation: translation, book: book, chapter: chapter, heading: heading, segment: segment, verse: verse, content: "In the beginning God created the heavens and the earth.", position: 3, show_verse: true, kind: "text")
        section.segments << segment

        expect(section.user_prompt).to eq <<~HEREDOC.strip
          <instructions>
          1. Generate a commentary and work exclusively with the following text excerpt from the Berean Standard Bible (BSB).
          2. When quoting or referring to the text, use the exact wording provided in the text excerpt.
          </instructions>

          <text>
          1 In the beginning God created the heavens and the earth.

          Genesis 1:1 BSB
          </text>
        HEREDOC
      end
    end

    context "when the section has multiple verses with complex fragments" do
      it 'returns the right user prompt' do
        section = FactoryBot.create(:translation_section, translation: translation, book: book, chapter: chapter, heading: heading, position: 1)

        # segment-1
        segment_1 = FactoryBot.create(:translation_segment, translation: translation, book: book, chapter: chapter, heading: heading, usx_position: 7, usx_style: 'pmo')
        verse_3 = FactoryBot.create(:translation_verse, translation: translation, book: book, chapter: chapter, number: 3)
        footnote_1 = FactoryBot.create(:translation_footnote, translation: translation, book: book, chapter: chapter, verse: verse_3, content: "Cited in 2 Corinthians 4:6")
        fragment_3a = FactoryBot.create(:translation_fragment, translation: translation, book: book, chapter: chapter, heading: heading, verse: verse_3, segment: segment_1, position: 3, show_verse: true, kind: "text", content: "And God said, “Let there be light,”")
        fragment_3b = FactoryBot.create(:translation_fragment, translation: translation, book: book, chapter: chapter, heading: heading, verse: verse_3, segment: segment_1, position: 4, show_verse: false, kind: "note", content: "1", fragmentable: footnote_1)
        fragment_3c = FactoryBot.create(:translation_fragment, translation: translation, book: book, chapter: chapter, heading: heading, verse: verse_3, segment: segment_1, position: 5, show_verse: false, kind: "text", content: "and there was light.")

        verse_4 = FactoryBot.create(:translation_verse, translation: translation, book: book, chapter: chapter, number: 4)
        fragment_4a = FactoryBot.create(:translation_fragment, translation: translation, book: book, chapter: chapter, heading: heading, verse: verse_4, segment: segment_1, position: 8, show_verse: true, kind: "text", content: "And God saw that the light was good, and He separated the light from the darkness.")

        verse_5 = FactoryBot.create(:translation_verse, translation: translation, book: book, chapter: chapter, number: 5)
        fragment_5a = FactoryBot.create(:translation_fragment, translation: translation, book: book, chapter: chapter, heading: heading, verse: verse_5, segment: segment_1, position: 11, show_verse: true, kind: "text", content: "God called the light “day,” and the darkness He called “night.”")

        # segment-2
        segment_2 = FactoryBot.create(:translation_segment, translation: translation, book: book, chapter: chapter, heading: heading, usx_position: 8, usx_style: 'pmo')
        footnote_2 = FactoryBot.create(:translation_footnote, translation: translation, book: book, chapter: chapter, verse: verse_5, content: "Literally day one")
        fragment_5b = FactoryBot.create(:translation_fragment, translation: translation, book: book, chapter: chapter, heading: heading, verse: verse_5, segment: segment_2, position: 1, show_verse: false, kind: "text", content: "And there was evening, and there was morning—the first day.")
        fragment_5c = FactoryBot.create(:translation_fragment, translation: translation, book: book, chapter: chapter, heading: heading, verse: verse_5, segment: segment_2, position: 2, show_verse: false, kind: "note", content: "2", fragmentable: footnote_2)

        section.segments << segment_1
        section.segments << segment_2

        expect(section.user_prompt).to eq <<~HEREDOC.strip
          <instructions>
          1. Generate a commentary and work exclusively with the following text excerpt from the Berean Standard Bible (BSB).
          2. When quoting or referring to the text, use the exact wording provided in the text excerpt.
          </instructions>

          <text>
          3 And God said, “Let there be light,”[a]and there was light.
          4 And God saw that the light was good, and He separated the light from the darkness.
          5 God called the light “day,” and the darkness He called “night.”
          And there was evening, and there was morning—the first day.[b]

          Genesis 1:3,4,5 BSB
          </text>

          <footnotes>
          [a]: Cited in 2 Corinthians 4:6
          [b]: Literally day one
          </footnotes>
        HEREDOC
      end
    end

    context "when the section has fragments with hidden verses" do
      it 'returns the right user prompt' do
        section = FactoryBot.create(:translation_section, translation: translation, book: book, chapter: chapter, heading: heading, position: 1)
        verse = FactoryBot.create(:translation_verse, translation: translation, book: book, chapter: chapter, number: 14)

        segment_1 = FactoryBot.create(:translation_segment, translation: translation, book: book, chapter: chapter, heading: heading, usx_position: 6, usx_style: 'q1')
        fragment_1 = FactoryBot.create(:translation_fragment, translation: translation, book: book, chapter: chapter, heading: heading, segment: segment_1, verse: verse, content: "“Because you have done this,", position: 1, show_verse: false, kind: "text")

        segment_2 = FactoryBot.create(:translation_segment, translation: translation, book: book, chapter: chapter, heading: heading, usx_position: 6, usx_style: 'q2')
        fragment_2 = FactoryBot.create(:translation_fragment, translation: translation, book: book, chapter: chapter, heading: heading, segment: segment_2, verse: verse, content: "cursed are you above all livestock", position: 1, show_verse: false, kind: "text")

        segment_3 = FactoryBot.create(:translation_segment, translation: translation, book: book, chapter: chapter, heading: heading, usx_position: 6, usx_style: 'q2')
        fragment_3 = FactoryBot.create(:translation_fragment, translation: translation, book: book, chapter: chapter, heading: heading, segment: segment_3, verse: verse, content: "and every beast of the field!", position: 1, show_verse: false, kind: "text")

        section.segments << segment_1
        section.segments << segment_2
        section.segments << segment_3

        expect(section.user_prompt).to eq <<~HEREDOC.strip
          <instructions>
          1. Generate a commentary and work exclusively with the following text excerpt from the Berean Standard Bible (BSB).
          2. When quoting or referring to the text, use the exact wording provided in the text excerpt.
          </instructions>

          <text>
          “Because you have done this,
          cursed are you above all livestock
          and every beast of the field!

          Genesis 1:14 BSB
          </text>
        HEREDOC
      end
    end
  end

  describe '.create_batch_request' do
    it 'returns a batch request' do
      system_prompt = FactoryBot.create :exposition_system_prompt, text: <<~HEREDOC.strip
        You are an AI providing commentary on texts from the Bible.
      HEREDOC
      # section-1
      section_1 = FactoryBot.create(:translation_section, translation: translation, book: book, chapter: chapter, heading: heading, position: 1, verse_spec: "1")
      segment_1 = FactoryBot.create(:translation_segment, translation: translation, book: book, chapter: chapter, heading: heading, usx_position: 6, usx_style: 'm')
      verse_1 = FactoryBot.create(:translation_verse, translation: translation, book: book, chapter: chapter, number: 1)
      FactoryBot.create(:translation_fragment, translation: translation, book: book, chapter: chapter, heading: heading, segment: segment_1, verse: verse_1, content: "In the beginning God created the heavens and the earth.", position: 1, show_verse: true, kind: "text")
      section_1.segments << segment_1

      # section-2
      section_2 = FactoryBot.create(:translation_section, translation: translation, book: book, chapter: chapter, heading: heading, position: 2, verse_spec: "13")
      segment_2 = FactoryBot.create(:translation_segment, translation: translation, book: book, chapter: chapter, heading: heading, usx_position: 6, usx_style: 'm')
      verse_2 = FactoryBot.create(:translation_verse, translation: translation, book: book, chapter: chapter, number: 13)
      FactoryBot.create(:translation_fragment, translation: translation, book: book, chapter: chapter, heading: heading, segment: segment_2, verse: verse_2, content: "And there was evening, and there was morning—the third day.", position: 1, show_verse: true, kind: "text")
      section_2.segments << segment_2

      sections = Bible::Section.where(translation: translation, book: book)
      batch_request = Bible::Section.create_batch_request("exposition", sections, system_prompt)

      aggregate_failures do
        expect(batch_request.name).to eq "exposition"
        expect(batch_request.status).to eq "requested"

        expect(batch_request.data[0]["custom_id"]).to match(/^\d+$/)
        expect(batch_request.data[0]["method"]).to eq "POST"
        expect(batch_request.data[0]["url"]).to eq ExpositionService::ENDPOINT_RESPONSES
        expect(batch_request.data[0]["body"]["input"]).to eq <<~HEREDOC.strip
          <instructions>
          1. Generate a commentary and work exclusively with the following text excerpt from the Berean Standard Bible (BSB).
          2. When quoting or referring to the text, use the exact wording provided in the text excerpt.
          </instructions>

          <text>
          1 In the beginning God created the heavens and the earth.

          Genesis 1:1 BSB
          </text>
        HEREDOC
        expect(batch_request.data[0]["body"]["instructions"]).to eq "You are an AI providing commentary on texts from the Bible."
        expect(batch_request.data[0]["body"]["max_output_tokens"]).to eq ExpositionService::MAX_OUTPUT_TOKENS
        expect(batch_request.data[0]["body"]["model"]).to eq ExpositionService::MODEL
        expect(batch_request.data[0]["body"]["text"]["format"]).to eq JSON.parse(Exposition::STRUCTURED_OUTPUT_JSON_SCHEMA)
        expect(batch_request.data[0]["body"]["stream"]).to be false
        expect(batch_request.data[0]["body"]["store"]).to be false
        expect(batch_request.data[0]["body"]["temperature"]).to eq ExpositionService::TEMPERATURE
        expect(batch_request.data[0]["body"]["top_p"]).to eq ExpositionService::TOP_P

        # section-2
        expect(batch_request.data[1]["custom_id"]).to match(/^\d+$/)
        expect(batch_request.data[1]["method"]).to eq "POST"
        expect(batch_request.data[1]["url"]).to eq ExpositionService::ENDPOINT_RESPONSES
        expect(batch_request.data[1]["body"]["input"]).to eq <<~HEREDOC.strip
          <instructions>
          1. Generate a commentary and work exclusively with the following text excerpt from the Berean Standard Bible (BSB).
          2. When quoting or referring to the text, use the exact wording provided in the text excerpt.
          </instructions>

          <text>
          13 And there was evening, and there was morning—the third day.

          Genesis 1:13 BSB
          </text>
        HEREDOC
        expect(batch_request.data[1]["body"]["instructions"]).to eq "You are an AI providing commentary on texts from the Bible."
        expect(batch_request.data[1]["body"]["max_output_tokens"]).to eq ExpositionService::MAX_OUTPUT_TOKENS
        expect(batch_request.data[1]["body"]["model"]).to eq ExpositionService::MODEL
        expect(batch_request.data[1]["body"]["text"]["format"]).to eq JSON.parse(Exposition::STRUCTURED_OUTPUT_JSON_SCHEMA)
        expect(batch_request.data[1]["body"]["stream"]).to be false
        expect(batch_request.data[1]["body"]["store"]).to be false
        expect(batch_request.data[1]["body"]["temperature"]).to eq ExpositionService::TEMPERATURE
        expect(batch_request.data[1]["body"]["top_p"]).to eq ExpositionService::TOP_P
      end
    end
  end
end
