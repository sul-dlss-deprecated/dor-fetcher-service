# frozen_string_literal: true

require_relative 'boot'

# Just requiring the parts we need
require 'action_controller/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# rubocop:disable Rails/Output
module DorFetcherService
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Initialize configuration defaults
    config.load_defaults 5.2

    # Add in files in lib/, such as the fetcher module
    config.autoload_paths << Rails.root.join('lib')

    # Config values set below here are used by the application
    config.app_name = 'DORFetcherService'

    begin
      config.solr_url = config_for(:solr)['url']
    rescue StandardError
      puts 'WARNING: config/solr.yml config not found'
    end

    begin
      config.solr_terms = config_for(:solr_terms)
    rescue StandardError
      puts 'WARNING: config/solr_terms.yml config not found'
    end

    begin
      config.time_zone = 'UTC'
    rescue StandardError
      puts 'WARNING: could not configure time zone to utc'
    end
  end
end

# Convenience constant for SOLR
begin
  SOLR = RSolr.connect url: Rails.application.config.solr_url
rescue StandardError
  puts 'WARNING: Could not configure solr url'
end

begin
  SOLR_TERMS = Rails.application.config.solr_terms

  # Convience constants for Solr Fields
  ID_FIELD = SOLR_TERMS['id_field']
  TYPE_FIELD = SOLR_TERMS['fedora_type_field']
  CATKEY_FIELD = SOLR_TERMS['catkey_field']
  TITLE_FIELD = SOLR_TERMS['title_field']
  TITLE_FIELD_ALT = SOLR_TERMS['title_field_alt']
  LAST_CHANGED_FIELD = SOLR_TERMS['last_changed']
  FEDORA_PREFIX = SOLR_TERMS['fedora_prefix']
  DRUID_PREFIX = SOLR_TERMS['druid_prefix']
  FEDORA_TYPES = {
    collection: SOLR_TERMS['collection_type'],
    apo: SOLR_TERMS['apo_type'],
    item: SOLR_TERMS['item_type'],
    set: SOLR_TERMS['set_type']
  }.freeze
  CONTROLLER_TYPES = {
    collection: SOLR_TERMS['collection_field'],
    apo: SOLR_TERMS['apo_field'],
    tag: SOLR_TERMS['tag_field']
  }.freeze
rescue StandardError
  puts 'WARNING: Could not configure solr terms'
end
# rubocop:enable Rails/Output
