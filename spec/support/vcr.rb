VCR.configure do |config|
  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :webmock

  config.filter_sensitive_data('<TOKEN>') do |interaction|
    headers = interaction.request.headers

    if headers['Authorization'] && headers['Authorization'].first
      auths = headers['Authorization'].first
      if (match = auths.match(/^Bearer\s+([^,\s]+)/))
        match.captures.first
      end
    end
  end
end
