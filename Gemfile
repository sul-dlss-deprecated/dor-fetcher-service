# frozen_string_literal: true

source 'https://rubygems.org'

# Bootsnap is used by Rails 5.2 apps to reduce boot time. See https://github.com/rails/rails/pull/29313
gem 'bootsnap'
gem 'honeybadger', '~> 2.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
gem 'okcomputer'
# Use Puma as the app server
gem 'puma', '~> 3.0'
gem 'rails', '~> 5.2.2'
gem 'rest-client'
gem 'rsolr', '>=1.0.10'

group :development, :test do
  gem 'binding_of_caller'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'launchy'
  gem 'meta_request'
  gem 'pry-byebug'
  gem 'rubocop', '~> 0.60.0', require: false
  gem 'solr_wrapper', '~> 1.0'
  gem 'thin'
end

group :development do
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'awesome_print'
  gem 'capybara'
  gem 'coveralls'
  gem 'rspec-rails', '~> 3.1'
  gem 'vcr'
  gem 'webmock'
  gem 'yard'
end

# gems necessary for capistrano deployment
group :deployment do
  gem 'capistrano', '~> 3.0'
  gem 'capistrano-bundler'
  gem 'capistrano-rvm'
  gem 'dlss-capistrano'
end
