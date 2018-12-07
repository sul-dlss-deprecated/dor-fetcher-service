# frozen_string_literal: true

OkComputer.mount_at = 'status'
OkComputer.check_in_parallel = true

# Custom OkComputer check that reads VERSION file
class VersionCheck < OkComputer::AppVersionCheck
  def version
    File.read(Rails.root.join('VERSION')).strip
  end
end

# Custom OkComputer check that prints Rails environment
class RailsEnvCheck < OkComputer::Check
  def check
    # @note Cannot call `Rails.env.present?` bc 'present' is not a Rails env
    if Rails.env.to_s.present?
      mark_message "Rails environment: #{Rails.env}"
    else
      mark_failure
      mark_message 'Rails environment not set!'
    end
  end
end

# Custom OkComputer check that prints out application name
class AppNameCheck < OkComputer::Check
  def check
    if Rails.application.config.app_name
      mark_message "Application name: #{Rails.application.config.app_name}"
    else
      mark_failure
      mark_message 'Application name not set!'
    end
  end
end

# Custom OkComputer check that prints out last restart time
class LastRestartCheck < OkComputer::Check
  def check
    path = Rails.root.join('tmp', 'restart.txt')
    last_restart = File.exist?(path) ? File.new(path).mtime : 'n/a'
    mark_message "Last restart time: #{last_restart}"
  end
end

# Custom OkComputer check that prints out last deployed time
class LastDeployCheck < OkComputer::Check
  def check
    path = Rails.root.join('REVISION')
    last_deploy = File.exist?(path) ? File.new(path).mtime : 'n/a'
    mark_message "Last deployed time: #{last_deploy}"
  end
end

# Custom OkComputer check that prints out Solr URL
class SolrCheck < OkComputer::HttpCheck
  def initialize
    super("#{Rails.application.config.solr_url}/admin/ping")
  end

  def check
    mark_message "Solr URL: #{Rails.application.config.solr_url}" if perform_request
  rescue StandardError => exception
    mark_message "Error: '#{exception}'"
    mark_failure
  end
end

OkComputer::Registry.register 'app_name', AppNameCheck.new
OkComputer::Registry.register 'version', VersionCheck.new
OkComputer::Registry.register 'rails_env', RailsEnvCheck.new
OkComputer::Registry.register 'last_restart', LastRestartCheck.new
OkComputer::Registry.register 'last_deploy', LastDeployCheck.new
OkComputer::Registry.register 'solr', SolrCheck.new
