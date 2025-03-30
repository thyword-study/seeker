OpenAI.configure do |config|
  config.access_token = ENV.fetch("OPENAI_ACCESS_TOKEN", "sk-proj-xxxxxxx")
  config.log_errors = Rails.env.local?
end
