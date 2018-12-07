# frozen_string_literal: true

AboutPage.configure do |config|
  config.app           = { name: Rails.application.config.app_name, version: Rails.application.config.version }
  config.environment   = AboutPage::Environment.new(
    'Ruby' => /^(RUBY|GEM_|rvm)/, # This defines a "Ruby" subsection containing
    # environment variables whose names match the RegExp
  )
  config.request = AboutPage::RequestEnvironment.new(
    'HTTP Server' => /^(SERVER_|POW_)/ # This defines an "HTTP Server" subsection containing
    # request variables whose names match the RegExp
  )
  config.dependencies = AboutPage::Dependencies.new
end
