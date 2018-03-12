require 'solr_wrapper'
if Rails.env.test? || Rails.env.development?
  require 'rest_client'
end

desc 'Run continuous integration suite (assuming solr_wrapper is not yet started)'
task :ci do
  unless Rails.env.test?
    system('bundle exec rake ci RAILS_ENV=test')
  else
    system('bundle exec rake db:migrate RAILS_ENV=test')
    SolrWrapper.wrap do |solr|
      solr.with_collection(name: 'dorfetcher-test',
                           dir: File.join(File.expand_path("../..", File.dirname(__FILE__)), 'config', "solr", "conf")) do
        Rake::Task['dorfetcher:refresh_fixtures'].invoke
        Rake::Task['db:migrate'].invoke
        Rake::Task['db:fixtures:load'].invoke
        Rake::Task['db:seed'].invoke
        system('bundle exec rspec spec --color')
      end
    end
  end
end

desc 'Assuming Solr is already running - then migrate, reload all fixtures and run rspec'
task :local_ci do
  unless Rails.env.test?
    system('bundle exec rake local_ci RAILS_ENV=test')
  else
    Rake::Task['dorfetcher:refresh_fixtures'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:fixtures:load'].invoke
    Rake::Task['db:seed'].invoke
    system('bundle exec rspec spec --color')
  end
end

namespace :dorfetcher do
  desc 'Copy just shared yml files'
  task :config_yml do
    %w(database solr secrets).each do |f|
      next if File.exist? "#{Rails.root}/config/#{f}.yml"
      cp("#{Rails.root}/config/#{f}.yml.example", "#{Rails.root}/config/#{f}.yml", :verbose => true)
    end
  end

  desc 'Delete and index all fixtures in solr'
  task :refresh_fixtures do
    unless Rails.env.production? || Rails.env.staging? || !DorFetcherService::Application.config.solr_url.include?('8983')
      WebMock.disable! if Rails.env.test? # Webmock will block all http connections by default under test, allow us to reload the fixtures
      Rake::Task['dorfetcher:delete_records_in_solr'].invoke
      Rake::Task['dorfetcher:index_fixtures'].invoke
      WebMock.enable! if Rails.env.test?  # Bring webmock back online
    else
      puts "Refusing to delete since we're running under the #{Rails.env} environment or not on port 8983. You know, for safety."
    end
  end

  desc 'Index all fixtures into solr'
  task :index_fixtures do
    add_docs = Dir.glob("#{Rails.root}/spec/fixtures/*.xml").map { |file| File.read(file) }
    puts "Adding #{add_docs.count} documents to #{DorFetcherService::Application.config.solr_url}"
    RestClient.post "#{DorFetcherService::Application.config.solr_url}/update?commit=true", "<update><add>#{add_docs.join(" ")}</add></update>", :content_type => 'text/xml'
  end

  desc 'Clean up saved items - remove any saved items which reference items/solr documents that do not exist'
  task :cleanup_saved_items => :environment do |t, args|
    SavedItem.all.each { |saved_item| saved_item.destroy if saved_item.solr_document.nil? }
  end

  desc 'Delete all records in solr'
  task :delete_records_in_solr do
    unless Rails.env.production? || Rails.env.staging? || !DorFetcherService::Application.config.solr_url.include?('8983')
      puts "Deleting all solr documents from #{DorFetcherService::Application.config.solr_url}"
      puts DorFetcherService::Application.config.solr_url
      RestClient.post "#{DorFetcherService::Application.config.solr_url}/update?commit=true", '<delete><query>*:*</query></delete>' , :content_type => 'text/xml'
    else
      puts "Refusing to delete since we're running under the #{Rails.env} environment or not on port 8983. You know, for safety."
    end
  end
end
