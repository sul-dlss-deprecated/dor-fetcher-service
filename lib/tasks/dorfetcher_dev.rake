# frozen_string_literal: true

return unless Rails.env.test? || Rails.env.development?

require 'rest_client'

namespace :dorfetcher do
  desc 'Delete and index all fixtures in solr'
  task :refresh_fixtures do
    WebMock.disable! if Rails.env.test? # Webmock will block all http connections by default under test, allow us to reload the fixtures
    Rake::Task['dorfetcher:delete_records_in_solr'].invoke
    Rake::Task['dorfetcher:index_fixtures'].invoke
    WebMock.enable! if Rails.env.test?  # Bring webmock back online
  end

  desc 'Delete all records in solr'
  task delete_records_in_solr: :environment do
    puts "Deleting all solr documents from #{Rails.application.config.solr_url}"
    puts Rails.application.config.solr_url
    RestClient.post "#{Rails.application.config.solr_url}/update?commit=true", '<delete><query>*:*</query></delete>', content_type: 'text/xml'
  end

  # rubocop:disable Rails/FilePath
  desc 'Index all fixtures into solr'
  task index_fixtures: :environment do
    add_docs = Dir.glob("#{Rails.root}/spec/fixtures/*.xml").map { |file| File.read(file) }
    puts "Adding #{add_docs.count} documents to #{Rails.application.config.solr_url}"
    RestClient.post "#{Rails.application.config.solr_url}/update?commit=true", "<update><add>#{add_docs.join(' ')}</add></update>", content_type: 'text/xml'
  end
  # rubocop:enable Rails/FilePath
end
