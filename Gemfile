source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.3.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 7.1.3.2'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# API stack
gem 'trailblazer-rails'
gem 'trailblazer-context'

gem "trailblazer-activity-dsl-linear"
gem "trailblazer-activity"
gem "trailblazer-developer"
gem "trailblazer-macro"
gem "trailblazer-macro-contract"
gem "trailblazer-operation"
gem "trailblazer-endpoint"

gem 'grape'
gem 'rack-cors', '1.1.1', require: 'rack/cors'
gem 'multi_json'
gem "reform", "2.6.1"
gem "disposable", github: "apotonick/disposable", branch: "master"
gem 'dry-validation'

gem "sqlite3"

# JWT Token library
gem 'jwt'

# For creating dummy data
gem 'faker'

# Pagination
gem 'will_paginate', '~> 3.1.0'

# Use Active Storage variant
gem 'image_processing', '~> 1.0'

# support for base64 images in Active Storage
gem 'active_storage_base64', '~> 2.0.0'
gem 'base64'

# user password encryption
gem 'bcrypt'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# email validation
gem 'email_validator'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :test do
  gem 'rspec-rails'
  gem 'factory_bot_rails'
end

group :development do
  gem 'listen', '~> 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
