# ExpositionService generates an exposition commentary using the OpenAI API.
#
# It leverages a predefined JSON schema to structure the output into components
# like Bible text, context, key themes, analyses, cross-references, alternative
# interpretations, personal applications, Christ-centered insights, reflections
# and a summary.
#
# The service also includes a method to upload batch files in JSONL format for
# processing by the OpenAI API and a method to create a batch of responses.
#
class ExpositionService
  # The time frame within which the batch should be processed.
  BATCH_COMPLETION_WINDOW = "24h"

  # Endpoint for the responses API
  ENDPOINT_RESPONSES = "/v1/responses"

  # Maximum number of tokens allowed in the output.
  MAX_OUTPUT_TOKENS = 10_000

  # Model identifier for the OpenAI API.
  MODEL = "gpt-4o"

  # Sampling temperature for the API call.
  TEMPERATURE = 1.0

  # Top-p (nucleus sampling) parameter for the API call.
  TOP_P = 1.0

  # Returns a memoized instance of the OpenAI client.
  #
  # @return [OpenAI::Client] the client instance used for API requests.
  def client
    @client ||= OpenAI::Client.new
  end

  # Creates a batch of responses using the provided batch file ID.
  #
  # This method sends a request to the OpenAI API to create a batch of responses
  # based on the input file ID. The batch is processed with a completion window
  # of 24 hours.
  #
  # @param batch_file_id [String] The ID of the batch file to be processed.
  # @return [OpenAI::Response] The response from the OpenAI API.
  # @raise [StandardError] If the API call fails, an error is raised.
  def create_batch(batch_file_id)
    parameters = {
      input_file_id: batch_file_id,
      endpoint: ENDPOINT_RESPONSES,
      completion_window: BATCH_COMPLETION_WINDOW
    }

    begin
      response = client.batches.create(parameters: parameters)
    rescue StandardError => e
      Rails.logger.error "Error in ExpositionService#create_batch: #{e.message}"

      raise e
    end

    response
  end

  # Generates an exposition commentary using the provided system and user prompts.
  #
  # @param system_prompt [String] The system-level instructions for the AI.
  # @param user_prompt [String] The user's input, typically including Bible text or related query.
  # @return [OpenAI::Response] The structured response from the OpenAI API.
  # @raise [StandardError] If the API call fails, an error is raised.
  def exposit(system_prompt:, user_prompt:)
    parameters = {
      input: user_prompt,
      instructions: system_prompt,
      max_output_tokens: MAX_OUTPUT_TOKENS,
      model: MODEL,
      text: { format: JSON.parse(Exposition::STRUCTURED_OUTPUT_JSON_SCHEMA) },
      stream: false,
      store: false,
      temperature: TEMPERATURE,
      top_p: TOP_P
    }

    begin
      response = client.responses.create(parameters: parameters)
    rescue StandardError => e
      Rails.logger.error "Error in ExpositionService#exposit: #{e.message}"

      raise e
    end

    response
  end

  # Uploads a JSONL batch file to OpenAI for processing.
  #
  # @param request_data [String] Array of hashes to convert to JSONL.
  # @return [OpenAI::File] The uploaded file object.
  # @raise [StandardError] If the API call fails, an error is raised.
  def upload_batch_file(request_data)
    begin
      jsonl_data = request_data.map { |rd| rd.to_json }.join("\n")
      jsonl_file = Tempfile.new([ "exposition-batch", ".jsonl" ])
      jsonl_file.write(jsonl_data)
      jsonl_file.rewind

      batch_file = client.files.upload(parameters: { file: jsonl_file.path, purpose: "batch" })
      Rails.logger.info "Batch file uploaded successfully: #{batch_file["id"]}"
    rescue StandardError => e
      Rails.logger.error "Error in ExpositionService#upload_batch_file: #{e.message}"

      raise e
    ensure
      if jsonl_file
        jsonl_file.close
        jsonl_file.unlink
      end
    end

    batch_file
  end
end
