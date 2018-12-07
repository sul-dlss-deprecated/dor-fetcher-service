# frozen_string_literal: true

return unless Rails.env.test? || Rails.env.development?

require 'rubocop/rake_task'
RuboCop::RakeTask.new(:rubocop) do |task|
  task.fail_on_error = true
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:rspec)

desc 'Setup/fresh data and run specs'
task :spec_with_setup do
  Rake::Task['dorfetcher:config_yml'].invoke if ENV['CI']
  Rake::Task['dorfetcher:refresh_fixtures'].invoke
  Rake::Task['db:migrate'].invoke
  Rake::Task['db:fixtures:load'].invoke
  Rake::Task['db:seed'].invoke
  Rake::Task['rspec'].invoke
end

desc 'Run continuous integration suite (assuming solr_wrapper is not yet started)'
task :ci do
  require 'solr_wrapper'
  SolrWrapper.wrap do |solr|
    solr.with_collection(name: 'dorfetcher-test',
                         dir: File.join(File.expand_path('../..', File.dirname(__FILE__)), 'config', 'solr', 'conf')) do
      Rake::Task['spec_with_setup'].invoke
    end
  end
end

# Without this line RSpec forces the first task in the :default chain to be :spec, which we don't need to run twice
task(:default).clear
task default: ['rubocop', 'dorfetcher:config_yml', 'rspec']
