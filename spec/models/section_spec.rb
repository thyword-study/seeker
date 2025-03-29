require 'rails_helper'

RSpec.describe Section, type: :model do
  let(:bible) { FactoryBot.create(:bible_bsb) }
  let(:book) { FactoryBot.create(:book, bible: bible, title: "Genesis") }
  let(:chapter) { FactoryBot.create(:chapter, bible: bible, book: book, number: 1) }
  let(:heading) { FactoryBot.create(:heading, bible: bible, book: book, chapter: chapter) }

  describe '#user_prompt' do
    let(:bible) { FactoryBot.create(:bible_bsb) }
    let(:book) { FactoryBot.create(:book, bible: bible, title: "Genesis") }

    context "when the section has a single verse with simple fragments" do
      it 'returns the right user prompt' do
        section = FactoryBot.create(:section, bible: bible, book: book, chapter: chapter, heading: heading, position: 1)
        segment = FactoryBot.create(:segment, bible: bible, book: book, chapter: chapter, heading: heading, usx_position: 6, usx_style: 'm')
        verse = FactoryBot.create(:verse, bible: bible, book: book, chapter: chapter, number: 1)
        fragment = FactoryBot.create(:fragment, bible: bible, book: book, chapter: chapter, heading: heading, segment: segment, verse: verse, content: "In the beginning God created the heavens and the earth.", position: 3, show_verse: true, kind: "text")
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
        section = FactoryBot.create(:section, bible: bible, book: book, chapter: chapter, heading: heading, position: 1)

        # segment-1
        segment_1 = FactoryBot.create(:segment, bible: bible, book: book, chapter: chapter, heading: heading, usx_position: 7, usx_style: 'pmo')
        verse_3 = FactoryBot.create(:verse, bible: bible, book: book, chapter: chapter, number: 3)
        footnote_1 = FactoryBot.create(:footnote, bible: bible, book: book, chapter: chapter, verse: verse_3, content: "Cited in 2 Corinthians 4:6")
        fragment_3a = FactoryBot.create(:fragment, bible: bible, book: book, chapter: chapter, heading: heading, verse: verse_3, segment: segment_1, position: 3, show_verse: true, kind: "text", content: "And God said, “Let there be light,”")
        fragment_3b = FactoryBot.create(:fragment, bible: bible, book: book, chapter: chapter, heading: heading, verse: verse_3, segment: segment_1, position: 4, show_verse: false, kind: "note", content: "1", fragmentable: footnote_1)
        fragment_3c = FactoryBot.create(:fragment, bible: bible, book: book, chapter: chapter, heading: heading, verse: verse_3, segment: segment_1, position: 5, show_verse: false, kind: "text", content: "and there was light.")

        verse_4 = FactoryBot.create(:verse, bible: bible, book: book, chapter: chapter, number: 4)
        fragment_4a = FactoryBot.create(:fragment, bible: bible, book: book, chapter: chapter, heading: heading, verse: verse_4, segment: segment_1, position: 8, show_verse: true, kind: "text", content: "And God saw that the light was good, and He separated the light from the darkness.")

        verse_5 = FactoryBot.create(:verse, bible: bible, book: book, chapter: chapter, number: 5)
        fragment_5a = FactoryBot.create(:fragment, bible: bible, book: book, chapter: chapter, heading: heading, verse: verse_5, segment: segment_1, position: 11, show_verse: true, kind: "text", content: "God called the light “day,” and the darkness He called “night.”")

        # segment-2
        segment_2 = FactoryBot.create(:segment, bible: bible, book: book, chapter: chapter, heading: heading, usx_position: 8, usx_style: 'pmo')
        footnote_2 = FactoryBot.create(:footnote, bible: bible, book: book, chapter: chapter, verse: verse_5, content: "Literally day one")
        fragment_5b = FactoryBot.create(:fragment, bible: bible, book: book, chapter: chapter, heading: heading, verse: verse_5, segment: segment_2, position: 1, show_verse: false, kind: "text", content: "And there was evening, and there was morning—the first day.")
        fragment_5c = FactoryBot.create(:fragment, bible: bible, book: book, chapter: chapter, heading: heading, verse: verse_5, segment: segment_2, position: 2, show_verse: false, kind: "note", content: "2", fragmentable: footnote_2)

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
        section = FactoryBot.create(:section, bible: bible, book: book, chapter: chapter, heading: heading, position: 1)
        verse = FactoryBot.create(:verse, bible: bible, book: book, chapter: chapter, number: 14)

        segment_1 = FactoryBot.create(:segment, bible: bible, book: book, chapter: chapter, heading: heading, usx_position: 6, usx_style: 'q1')
        fragment_1 = FactoryBot.create(:fragment, bible: bible, book: book, chapter: chapter, heading: heading, segment: segment_1, verse: verse, content: "“Because you have done this,", position: 1, show_verse: false, kind: "text")

        segment_2 = FactoryBot.create(:segment, bible: bible, book: book, chapter: chapter, heading: heading, usx_position: 6, usx_style: 'q2')
        fragment_2 = FactoryBot.create(:fragment, bible: bible, book: book, chapter: chapter, heading: heading, segment: segment_2, verse: verse, content: "cursed are you above all livestock", position: 1, show_verse: false, kind: "text")

        segment_3 = FactoryBot.create(:segment, bible: bible, book: book, chapter: chapter, heading: heading, usx_position: 6, usx_style: 'q2')
        fragment_3 = FactoryBot.create(:fragment, bible: bible, book: book, chapter: chapter, heading: heading, segment: segment_3, verse: verse, content: "and every beast of the field!", position: 1, show_verse: false, kind: "text")

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
end
