require 'rails_helper'

RSpec.describe ExpositionService do
  let(:service) { ExpositionService.new }

  describe "#create_batch" do
    context "when the file id is valid" do
      it "returns a successful response" do
        batch_file_id = "file-JdhoBwvPwGcb5DVvZTkKwq"

        response = nil
        VCR.use_cassette('services/exposition_service/create_batch_200') do
          response = service.create_batch(batch_file_id)
        end

        aggregate_failures do
          expect(response["cancelled_at"]).to eq(nil)
          expect(response["cancelling_at"]).to eq(nil)
          expect(response["completed_at"]).to eq(nil)
          expect(response["completion_window"]).to eq(ExpositionService::BATCH_COMPLETION_WINDOW)
          expect(response["created_at"]).to eq(1743825229)
          expect(response["endpoint"]).to eq(ExpositionService::ENDPOINT_RESPONSES)
          expect(response["error_file_id"]).to eq(nil)
          expect(response["errors"]).to eq(nil)
          expect(response["expired_at"]).to eq(nil)
          expect(response["expires_at"]).to eq(1743911629)
          expect(response["failed_at"]).to eq(nil)
          expect(response["finalizing_at"]).to eq(nil)
          expect(response["id"]).to eq("batch_67f0a94dd3f88190aa0851cd92539a09")
          expect(response["in_progress_at"]).to eq(nil)
          expect(response["input_file_id"]).to eq(batch_file_id)
          expect(response["metadata"]).to eq(nil)
          expect(response["object"]).to eq("batch")
          expect(response["output_file_id"]).to eq(nil)
          expect(response["request_counts"]["completed"]).to eq(0)
          expect(response["request_counts"]["failed"]).to eq(0)
          expect(response["request_counts"]["total"]).to eq(0)
          expect(response["status"]).to eq("validating")
        end
      end
    end
  end

  describe "#exposit" do
    context "when the request is valid and successful" do
      it "returns the response" do
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

        response = nil
        VCR.use_cassette('services/exposition_service/exposit_200') do
          response = service.exposit(system_prompt: system_prompt, user_prompt: user_prompt)
        end

        aggregate_failures do
          expect(response["error"]).to eq(nil)
          expect(response["incomplete_details"]).to eq(nil)
          expect(response["output"][0]["content"][0]["type"]).to eq("output_text")
          expect(response["status"]).to eq("completed")

          schema = JSON.parse(Exposition::STRUCTURED_OUTPUT_JSON_SCHEMA)["schema"]
          result = response["output"][0]["content"][0]["text"]
          expect(JSON::Validator.validate(schema, result)).to be true
        end
      end
    end
  end

  describe "#upload_batch_file" do
    context "when the request data is valid" do
      it "returns a successful response" do
        request_data = [
          {
            custom_id: "request-1",
            method: "POST",
            url: ExpositionService::ENDPOINT_RESPONSES,
            body: {
              input: "Hello world!",
              instructions: "You are a helpful assistant.",
              model: ExpositionService::MODEL,
              max_output_tokens: ExpositionService::MAX_OUTPUT_TOKENS
            }
          },
          {
            custom_id: "request-2",
            method: "POST",
            url: ExpositionService::ENDPOINT_RESPONSES,
            body: {
              input: "Hello world!",
              instructions: "You are an unhelpful assistant.",
              model: ExpositionService::MODEL,
              max_output_tokens: ExpositionService::MAX_OUTPUT_TOKENS
            }
          }
        ]

        file = nil
        VCR.use_cassette('services/exposition_service/upload_batch_file_200') do
          file = service.upload_batch_file(request_data)
        end

        aggregate_failures do
          expect(file["bytes"]).to eq(372)
          expect(file["created_at"]).to eq(1743825080)
          expect(file["expires_at"]).to eq(nil)
          expect(file["filename"]).to eq("exposition-batch20250405-83656-vmf8ks.jsonl")
          expect(file["id"]).to eq("file-JdhoBwvPwGcb5DVvZTkKwq")
          expect(file["object"]).to eq("file")
          expect(file["purpose"]).to eq("batch")
          expect(file["status_details"]).to eq(nil)
          expect(file["status"]).to eq("processed")
        end
      end
    end
  end
end
