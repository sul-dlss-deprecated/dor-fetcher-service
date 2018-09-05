source 'https://rubygems.org'

gem 'rails', '~> 5.0.0', '>= 5.0.0.1'

# Use Puma as the app server
gem 'puma', '~> 3.0'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'rsolr', '>=1.0.10'
gem 'rest-client'

gem 'is_it_working'
gem 'about_page'

group :test do
  gem 'sqlite3'
  gem 'awesome_print'
  gem 'yard'
  gem 'vcr'
  gem 'webmock'
  gem 'rspec-rails', '~> 3.1'
  gem 'capybara'
  gem 'coveralls'
end

# gems necessary for capistrano deployment
group :deployment do
  gem 'capistrano', '~> 3.0'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'dlss-capistrano'
  gem 'capistrano-rvm'
end

group :production do
  gem 'mysql2'
end

group :development, :test do
  gem 'solr_wrapper', '~> 1.0'
  gem 'pry-byebug'
  gem 'binding_of_caller'
  gem 'meta_request'
  gem 'launchy'
  gem 'thin'
end

gem 'honeybadger', '~> 2.0'
