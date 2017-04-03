source 'https://rubygems.org'

gem 'rails', '>=4.1.6'
gem 'rsolr', '>=1.0.10'
gem 'rest-client'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'turbolinks'

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
  gem 'jettywrapper'
  gem 'pry-byebug'
  gem 'binding_of_caller'
  gem 'meta_request'
  gem 'launchy'
  gem 'thin'
end

gem 'honeybadger', '~> 2.0'
