module MarkdownHelper
  # Converts the given Markdown text into sanitized HTML.
  #
  # @param text [String] The Markdown text to be converted.
  # @return [String] The sanitized HTML string, allowing only specific tags.
  def markdown_to_html(text)
    html = Kramdown::Document.new(text).to_html
    sanitize(html, tags: %w[strong em p])
  end
end
