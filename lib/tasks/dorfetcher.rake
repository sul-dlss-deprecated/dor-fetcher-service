# frozen_string_literal: true

namespace :dorfetcher do
  desc 'Copy just shared yml files'
  task :config_yml do
    %w[database solr secrets].each do |f|
      next if File.exist?(Rails.root.join('config', "#{f}.yml"))

      cp(Rails.root.join('config', "#{f}.yml.example"),
         Rails.root.join('config', "#{f}.yml"),
         verbose: true)
    end
  end

  desc 'Clean up saved items - remove any saved items which reference items/solr documents that do not exist'
  task cleanup_saved_items: :environment do
    SavedItem.all.each { |saved_item| saved_item.destroy if saved_item.solr_document.nil? }
  end
end
