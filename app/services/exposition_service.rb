# ExpositionService generates an exposition commentary using the OpenAI API.
#
# It leverages a predefined JSON schema to structure the output into components
# like Bible text, context, key themes, analyses, cross-references, alternative
# interpretations, personal applications, Christ-centered insights, reflections
# and a summary.
#
# @example service = ExpositionService.new response = service.exposit(
#   system_prompt: "Your system instructions here", user_prompt: "Your Bible
#   text and query here" ) puts response
class ExpositionService
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
end
