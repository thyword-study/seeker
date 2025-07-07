source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.0.2"
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft"
# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem "kamal", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Annotates Rails/ActiveRecord Models, routes, fixtures, and others based on the
# database schema.
gem "annotaterb", "~> 4.16"

# Easiest way to manage multi-environment settings in any ruby project or
# framework.
gem "config", "~> 5.5", ">= 5.5.2"

# Kramdown is yet-another-markdown-parser but fast, pure Ruby, using a strict
# syntax definition and supporting several common extensions.
gem "kramdown", "~> 2.5", ">= 2.5.1"

# Use the OpenAI API with Ruby!
gem "ruby-openai", "~> 8.1"

# Integrate Tailwind CSS with the asset pipeline in Rails.
gem "tailwindcss-rails", "~> 4.3"

# A self-contained `tailwindcss` executable, wrapped up in a ruby gem. That's
# it. Nothing else.
gem "tailwindcss-ruby", "~> 4.1"

# Library for validating urls in Rails.
gem "validate_url", "~> 1.0", ">= 1.0.15"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Provides integration between factory_bot and rails 5.0 or newer.
  gem "factory_bot_rails", "~> 6.5"

  # Easily generates fake data: names, addresses, phone numbers, etc.
  gem "faker", "~> 3.5"

  # rspec-rails integrates the Rails testing helpers into RSpec.
  gem "rspec-rails", "~> 8.0"

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
end

group :test do
  # Strategies for cleaning databases using ActiveRecord. Can be used to ensure
  # a clean state for testing.
  gem "database_cleaner-active_record", "~> 2.2"

  # Ruby JSON Schema Validator.
  gem "json-schema", "~> 5.1", ">= 5.1.1"

  # Record your test suite's HTTP interactions and replay them during future
  # test runs for fast, deterministic, accurate tests.
  gem "vcr", "~> 6.3", ">= 6.3.1"

  # WebMock allows stubbing HTTP requests and setting expectations on HTTP
  # requests.
  gem "webmock", "~> 3.25", ">= 3.25.1"
end
