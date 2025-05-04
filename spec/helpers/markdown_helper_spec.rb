require "rails_helper"

RSpec.describe MarkdownHelper, type: :helper do
  describe "#markdown_to_html" do
    it "converts text to HTML" do
      markdown_text = "# Hello World"
      expected_html = "Hello World\n"
      result = helper.markdown_to_html(markdown_text)

      aggregate_failures do
        expect(result).to eq(expected_html)
        expect(result).to be_html_safe
      end
    end

    it "handles empty text" do
      markdown_text = ""
      expected_html = "\n"
      result = helper.markdown_to_html(markdown_text)

      aggregate_failures do
        expect(result).to eq(expected_html)
        expect(result).to be_html_safe
      end
    end

    it "sanitizes unsafe HTML by removing disallowed tags" do
      markdown_text = "<script>alert('XSS')</script><strong>Bold</strong>"
      expected_html = "alert('XSS')\n<p><strong>Bold</strong></p>\n"
      result = helper.markdown_to_html(markdown_text)

      aggregate_failures do
        expect(result).to eq(expected_html)
        expect(result).to be_html_safe
      end
    end

    it "allows only specific HTML tags" do
      markdown_text = "<em>Italic</em><strong>Bold</strong><a href='url'>Link</a>"
      expected_html = "<p><em>Italic</em><strong>Bold</strong>Link</p>\n"
      result = helper.markdown_to_html(markdown_text)

      aggregate_failures do
        expect(result).to eq(expected_html)
        expect(result).to be_html_safe
      end
    end
  end

  describe "#strip_markdown" do
    it "removes Markdown formatting and returns plain text" do
      markdown_text = "# Hello *World*"
      expected_text = "Hello World"
      result = helper.strip_markdown(markdown_text)

      expect(result).to eq(expected_text)
    end

    it "handles empty text" do
      markdown_text = ""
      expected_text = ""
      result = helper.strip_markdown(markdown_text)

      expect(result).to eq(expected_text)
    end

    it "removes HTML tags and returns plain text" do
      markdown_text = "<strong>Bold</strong> and <em>Italic</em>"
      expected_text = "Bold and Italic"
      result = helper.strip_markdown(markdown_text)

      expect(result).to eq(expected_text)
    end

    it "handles complex Markdown and returns plain text" do
      markdown_text = "# Title\n\nThis is a **bold** statement with *italic* text."
      expected_text = "Title\n\nThis is a bold statement with italic text."
      result = helper.strip_markdown(markdown_text)

      expect(result).to eq(expected_text)
    end
  end
end
