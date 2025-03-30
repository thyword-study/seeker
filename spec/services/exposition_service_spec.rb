require 'rails_helper'

RSpec.describe ExpositionService do
  describe "#exposit" do
    context "when the request is valid and successful" do
      it "returns the response" do
        service = ExpositionService.new
        system_prompt = <<~HEREDOC
          You are an AI providing commentary on texts from the Bible.
        HEREDOC
        user_prompt = <<~HEREDOC
          <instructions>
          1. Generate a commentary and work exclusively with the following text excerpt from the Berean Standard Bible (BSB).
          2. When quoting or referring to the text, use the exact wording provided in the text excerpt.
          </instructions>

          <text>
          1 In the beginning God created the heavens and the earth.

          Genesis 1:1 BSB
          </text>
        HEREDOC

        response = ""
        VCR.use_cassette('services/exposition_service/exposit_200') do
          response = service.exposit(system_prompt: system_prompt, user_prompt: user_prompt)
        end

        expect(response).to eq("")
      end
    end
  end
end
