require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

VERSION = File.read('VERSION')

module DorFetcherService
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Add in files in lib/, such as the fetcher module
    config.autoload_paths << Rails.root.join('lib')

    config.version = VERSION # read from VERSION file at base of website
    config.app_name = 'DORFetcherService'

    load_yaml_config = lambda do |yaml_file|
      full_path = File.expand_path(File.join(File.dirname(__FILE__), yaml_file))
      yaml_erb  = ERB.new(IO.read(full_path)).result(binding)
      yaml      = YAML.load(yaml_erb)
      return yaml[Rails.env]
    end

    begin
      config.solr_url = load_yaml_config.call('solr.yml')['url']
      # puts load_yaml_config.call('solr.yml')['url']
    rescue
      puts 'WARNING: config/solr.yml config not found'
    end

    begin
      config.solr_terms = load_yaml_config.call('solr_terms.yml')
      # puts load_yaml_config.call('solr_terms.yml')
    rescue
      puts 'WARNING: config/solr_terms.yml config not found'
    end

    begin
      config.time_zone = 'UTC'
    rescue
      puts 'WARNING: could not configure time zone to utc'
    end
  end
end

# Convienence constant for SOLR
begin
  Solr = RSolr.connect :url => DorFetcherService::Application.config.solr_url
rescue
  puts 'WARNING: Could not configure solr url'
end

begin
  Solr_terms = DorFetcherService::Application.config.solr_terms

  # Convience constants for Solr Fields
  ID_Field           = Solr_terms['id_field']
  Type_Field         = Solr_terms['fedora_type_field']
  CatKey_Field       = Solr_terms['catkey_field']
  Title_Field        = Solr_terms['title_field']
  Title_Field_Alt    = Solr_terms['title_field_alt']
  Last_Changed_Field = Solr_terms['last_changed']
  Fedora_Prefix      = Solr_terms['fedora_prefix']
  Druid_Prefix       = Solr_terms['druid_prefix']
  Fedora_Types     = {:workflow => Solr_terms['workflow_type'], :collection => Solr_terms['collection_type'], :apo => Solr_terms['apo_type'], :item => Solr_terms['item_type'], :set => Solr_terms['set_type']}.freeze
  Controller_Types = {:collection => Solr_terms['collection_field'], :apo => Solr_terms['apo_field'], :tag => Solr_terms['tag_field']}.freeze
rescue
  puts 'WARNING: Could not configure solr terms'
end

# solr_fields = {:apo_field => apo_field, :collection_field => collection_field}
