OpenAI.configure do |config|
  config.access_token = ENV.fetch("OPENAI_ACCESS_TOKEN", "sk-proj-xxxxxxx")
  config.organization_id = ENV.fetch("OPENAI_ORGANIZATION_ID", "org-xxxxxxx")
  config.log_errors = Rails.env.local?
end
