VCR.configure do |config|
  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :webmock

  config.filter_sensitive_data('[REDACTED]') do |interaction|
    headers = interaction.request.headers

    if headers['Authorization'] && headers['Authorization'].first
      auths = headers['Authorization'].first
      if (match = auths.match(/^Bearer\s+([^,\s]+)/))
        match.captures.first
      end
    end
  end

  config.filter_sensitive_data('[REDACTED]') do |interaction|
    headers = interaction.request.headers

    if headers['Openai-Organization'] && headers['Openai-Organization'].first
      orgs = headers['Openai-Organization'].first
      if (match = orgs.match(/^org-([^,\s]+)/))
        match.captures.first
      end
    end
  end
end
