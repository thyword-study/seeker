require 'rails_helper'

RSpec.describe ExpositionService do
  let(:service) { ExpositionService.new }
  let(:batch_request_data) do
    [
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
  end

  describe "#batch_file_content" do
    context "when the request is valid and successful" do
      it "returns the response" do
        output_file_id = "file-AaebNvGyKSdDqXg1Wr5sMn"

        response = nil
        VCR.use_cassette('services/exposition_service/batch_file_content_200') do
          response = service.batch_file_content(output_file_id)
        end

        aggregate_failures do
          expect(response[0]["id"]).to eq("batch_req_67eee9915c9881908a55275469c8ddb3")
          expect(response[0]["custom_id"]).to eq("1")
          expect(response[0]["error"]).to eq(nil)
          expect(response[0]["response"]["body"]["error"]).to eq(nil)
          expect(response[0]["response"]["body"]["incomplete_details"]).to eq(nil)
          expect(response[0]["response"]["body"]["output"][0]["content"][0]["type"]).to eq("output_text")
          expect(response[0]["response"]["body"]["status"]).to eq("completed")

          expect(response[1]["id"]).to eq("batch_req_67eee9916ddc81908822dd835b8cc76d")
          expect(response[1]["custom_id"]).to eq("2")
          expect(response[1]["error"]).to eq(nil)
          expect(response[1]["response"]["body"]["error"]).to eq(nil)
          expect(response[1]["response"]["body"]["incomplete_details"]).to eq(nil)
          expect(response[1]["response"]["body"]["output"][0]["content"][0]["type"]).to eq("output_text")
          expect(response[1]["response"]["body"]["status"]).to eq("completed")

          schema = JSON.parse(Exposition::STRUCTURED_OUTPUT_JSON_SCHEMA)["schema"]
          result_1 = response[0]["response"]["body"]["output"][0]["content"][0]["text"]
          result_2 = response[1]["response"]["body"]["output"][0]["content"][0]["text"]
          expect(JSON::Validator.validate(schema, result_1)).to be true
          expect(JSON::Validator.validate(schema, result_2)).to be true
        end
      end
    end
  end

  describe "#create_batch" do
    context "when the file id is valid" do
      it "returns a successful response" do
        batch_request = FactoryBot.create(:exposition_batch_request, {
            input_file_id: "file-JdhoBwvPwGcb5DVvZTkKwq",
            input_file_uploaded_at: Time.current,
            name: "exposition-batch20250405-83656-vmf8ks",
            status: "uploaded",
            data: batch_request_data
          }
        )

        updated_batch_request = nil
        VCR.use_cassette('services/exposition_service/create_batch_200') do
          updated_batch_request = service.create_batch(batch_request)
        end

        aggregate_failures do
          expect(updated_batch_request.batch_id).to eq "batch_67f0a94dd3f88190aa0851cd92539a09"
          expect(updated_batch_request.status).to eq "validating"
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

  describe "#retrieve_batch" do
    context "when the batch is complete" do
      it "returns a successful response" do
        batch_request = FactoryBot.create(:exposition_batch_request, {
            batch_id: "batch_67f0a94dd3f88190aa0851cd92539a09",
            input_file_id: "file-JdhoBwvPwGcb5DVvZTkKwq",
            input_file_uploaded_at: Time.current,
            name: "exposition-batch20250405-83656-vmf8ks",
            status: "in_progress",
            data: batch_request_data
          }
        )

        updated_batch_request = nil
        VCR.use_cassette('services/exposition_service/retrieve_batch_200_completed') do
          updated_batch_request = service.retrieve_batch(batch_request)
        end

        aggregate_failures do
          expect(updated_batch_request.status).to eq "completed"
          expect(updated_batch_request.error_file_id).to eq(nil)
          expect(updated_batch_request.output_file_id).to eq "file-1iUaZhdERigedcLsDt6mA7"

          expect(updated_batch_request.in_progress_at).to eq Time.parse("2025-04-05 03:53:50 UTC")
          expect(updated_batch_request.cancelling_at).to eq(nil)
          expect(updated_batch_request.expires_at).to eq Time.parse("2025-04-06 03:53:49 UTC")
          expect(updated_batch_request.finalizing_at).to eq Time.parse("2025-04-05 03:54:01 UTC")
          expect(updated_batch_request.completed_at).to eq Time.parse("2025-04-05 03:54:01 UTC")
          expect(updated_batch_request.failed_at).to eq(nil)
          expect(updated_batch_request.cancelled_at).to eq(nil)
          expect(updated_batch_request.expired_at).to eq(nil)

          expect(updated_batch_request.requested_total_count).to eq 2
          expect(updated_batch_request.requested_completed_count).to eq 2
          expect(updated_batch_request.requested_failed_count).to eq 0
        end
      end
    end

    context "when the batch has errors" do
      it "returns a successful response" do
        batch_request = FactoryBot.create(:exposition_batch_request, {
            batch_id: "batch_67f01a96aef0819090cccd8b5e42375b",
            input_file_id: "file-2xTVLy9JYc7beLuAd2oTgw",
            input_file_uploaded_at: Time.current,
            name: "exposition-batch20250405-83656-vmf8ks",
            status: "in_progress",
            data: batch_request_data
          }
        )

        updated_batch_request = nil
        VCR.use_cassette('services/exposition_service/retrieve_batch_200_failed') do
          updated_batch_request = service.retrieve_batch(batch_request)
        end

        aggregate_failures do
          expect(updated_batch_request.status).to eq "failed"
          expect(updated_batch_request.error_file_id).to eq(nil)
          expect(updated_batch_request.output_file_id).to eq(nil)

          expect(updated_batch_request.in_progress_at).to eq(nil)
          expect(updated_batch_request.cancelling_at).to eq(nil)
          expect(updated_batch_request.expires_at).to eq Time.parse("2025-04-05 17:44:54 UTC")
          expect(updated_batch_request.finalizing_at).to eq(nil)
          expect(updated_batch_request.completed_at).to eq(nil)
          expect(updated_batch_request.failed_at).to eq Time.parse("2025-04-04 17:44:55 UTC")
          expect(updated_batch_request.cancelled_at).to eq(nil)
          expect(updated_batch_request.expired_at).to eq(nil)

          expect(updated_batch_request.requested_total_count).to eq 0
          expect(updated_batch_request.requested_completed_count).to eq 0
          expect(updated_batch_request.requested_failed_count).to eq 0
        end
      end
    end
  end

  describe "#upload_batch_file" do
    context "when the request data is valid" do
      it "returns a successful response" do
        batch_request = FactoryBot.create(:exposition_batch_request, {
            name: "exposition-batch",
            data: batch_request_data
          }
        )

        VCR.use_cassette('services/exposition_service/upload_batch_file_200') do
          batch_request = service.upload_batch_file(batch_request)
        end

        aggregate_failures do
          expect(batch_request.status).to eq "uploaded"
          expect(batch_request.input_file_id).to eq "file-JdhoBwvPwGcb5DVvZTkKwq"
          expect(batch_request.input_file_uploaded_at.utc).to be_within(1.second).of Time.current
        end
      end
    end
  end
end
