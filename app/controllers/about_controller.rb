# frozen_string_literal: true

class AboutController < ApplicationController
  def index
    render plain: 'ok', status: :ok
  end

  def version
    @result = {
      app_name: Rails.application.config.app_name,
      rails_env: Rails.env,
      version: Rails.application.config.version,
      last_restart: (File.exist?('tmp/restart.txt') ? File.new('tmp/restart.txt').mtime : 'n/a'),
      last_deploy: (File.exist?('REVISION') ? File.new('REVISION').mtime : 'n/a'),
      solr_url: Rails.application.config.solr_url
    }

    respond_to do |format|
      format.json { render json: @result.to_json }
      format.xml { render json: @result.to_xml(root: 'status') }
      format.html { render }
    end
  end
end
