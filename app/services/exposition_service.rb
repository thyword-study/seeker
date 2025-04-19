# ExpositionService interacts with the OpenAI API to generate structured
# exposition commentaries, upload batch files in JSONL format, create and
# retrieve batches of responses, and fetch file content.
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

  # Processes the content of a batch file from the OpenAI API.
  #
  # This method retrieves the content of a batch file using the output_file_id
  # from the provided batch request. It parses the content and creates
  # associated database records for exposition content, including alternative
  # interpretations, analyses, cross-references, Christ-centered insights, key
  # themes, and personal applications.
  #
  # @param batch_request [Exposition::BatchRequest] The batch request containing the output_file_id.
  # @return [Array<Exposition::Content>] The created exposition content records.
  # @raise [StandardError] If an error occurs during the API call or database operations.
  def batch_file_content(batch_request)
    begin
      contents = client.files.content(id: batch_request.output_file_id)
    rescue StandardError => e
      Rails.logger.error "Error in ExpositionService#batch_file_content: #{e.message}"

      raise e
    end

    ActiveRecord::Base.transaction do
      contents.map do |content|
        user_prompt = Exposition::UserPrompt.find(content["custom_id"])
        exposition = JSON.parse(content["response"]["body"]["output"][0]["content"][0]["text"]).deep_symbolize_keys!

        exposition_content = user_prompt.create_content!(
          context: exposition[:context],
          highlights: exposition[:highlights],
          interpretation_type: exposition[:interpretation_type],
          people: exposition[:people],
          places: exposition[:places],
          reflections: exposition[:reflections],
          section: user_prompt.section,
          summary: exposition[:summary],
          tags: exposition[:tags]
        )

        exposition[:alternative_interpretations].each do |alternative_interpretation|
          exposition_content.alternative_interpretations.create!(
            note: alternative_interpretation[:note],
            title: alternative_interpretation[:title]
          )
        end

        exposition[:analyses].each.with_index(1) do |analysis, position|
          exposition_content.analyses.create!(
            note: analysis[:note],
            part: analysis[:part],
            position: position
          )
        end

        exposition[:cross_references].each do |cross_reference|
          exposition_content.cross_references.create!(
            note: cross_reference[:note],
            reference: cross_reference[:reference]
          )
        end

        exposition[:christ_centered_insights].each do |christ_centered_insight|
          exposition_content.insights.create!(
            kind: "christ_centered",
            note: christ_centered_insight
          )
        end

        exposition[:key_themes].each do |key_theme|
          exposition_content.key_themes.create!(
            description: key_theme[:description],
            theme: key_theme[:theme]
          )
        end

        exposition[:personal_applications].each do |personal_application|
          exposition_content.personal_applications.create!(
            note: personal_application[:note],
            title: personal_application[:title]
          )
        end

        exposition_content
      end
    end
  end

  # Returns a memoized instance of the OpenAI client.
  #
  # @return [OpenAI::Client] the client instance used for API requests.
  def client
    @client ||= OpenAI::Client.new
  end

  # Creates a batch of responses for the given batch request.
  #
  # This method sends a request to the OpenAI API to create a batch of responses
  # using the input file associated with the provided batch request. It updates
  # the batch request record with the batch ID and status returned by the API.

  # @param batch_request [Exposition::BatchRequest] The batch request containing the input file ID.
  # @return [Exposition::BatchRequest] The updated batch request with batch ID and status.
  # @raise [StandardError] If the API call fails, an error is raised.
  def create_batch(batch_request)
    parameters = {
      input_file_id: batch_request.input_file_id,
      endpoint: ENDPOINT_RESPONSES,
      completion_window: BATCH_COMPLETION_WINDOW
    }

    begin
      batch = client.batches.create(parameters: parameters)
    rescue StandardError => e
      Rails.logger.error "Error in ExpositionService#create_batch: #{e.message}"

      raise e
    end

    batch_request.update!(
      batch_id: batch["id"],
      status: batch["status"]
    )
    batch_request
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

  # Retrieves a batch of responses using the provided batch ID.
  #
  # This method fetches the batch details from the OpenAI API using the batch ID
  # stored in the given batch request. It updates the batch request record with
  # the latest status and timestamps from the API response.
  #
  # @param batch_request [Exposition::BatchRequest] The batch request containing the batch ID.
  # @return [Exposition::BatchRequest] The updated batch request with the latest batch details.
  # @raise [StandardError] If the API call fails, an error is raised.
  def retrieve_batch(batch_request)
    begin
      batch = client.batches.retrieve(id: batch_request.batch_id)
    rescue StandardError => e
      Rails.logger.error "Error in ExpositionService#retrieve_batch: #{e.message}"

      raise e
    end

    batch_request.update!(
      status: batch["status"],
      error_file_id: batch["error_file_id"],
      output_file_id: batch["output_file_id"],

      in_progress_at: batch["in_progress_at"] ? Time.at(batch["in_progress_at"]) : nil,
      cancelling_at: batch["cancelling_at"] ? Time.at(batch["cancelling_at"]) : nil,
      expires_at: batch["expires_at"] ? Time.at(batch["expires_at"]) : nil,
      finalizing_at: batch["finalizing_at"] ? Time.at(batch["finalizing_at"]) : nil,
      completed_at: batch["completed_at"] ? Time.at(batch["completed_at"]) : nil,
      failed_at: batch["failed_at"] ? Time.at(batch["failed_at"]) : nil,
      cancelled_at: batch["cancelled_at"] ? Time.at(batch["cancelled_at"]) : nil,
      expired_at: batch["expired_at"] ? Time.at(batch["expired_at"]) : nil,

      requested_total_count: batch["request_counts"]["total"],
      requested_completed_count: batch["request_counts"]["completed"],
      requested_failed_count: batch["request_counts"]["failed"]
    )
    batch_request
  end

  # Uploads a JSONL batch file to OpenAI for processing and creates a
  # corresponding batch request record in the database.
  #
  # @param request_data [Array<Hash>] Array of hashes to convert to JSONL.
  # @return [Exposition::BatchRequest] The created batch request record.
  # @raise [StandardError] If the API call fails, an error is raised.
  def upload_batch_file(batch_request)
    begin
      jsonl_data = batch_request.data.map { |rd| rd.to_json }.join("\n")
      jsonl_file = Tempfile.new([ "#{batch_request.name.parameterize}-", ".jsonl" ])
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

    batch_request.update!(
      status: "uploaded",
      input_file_id: batch_file["id"],
      input_file_uploaded_at: Time.current,
    )
    batch_request
  end
end
